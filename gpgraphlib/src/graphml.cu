#include "graphml.h"
#include <stdio.h>

namespace cgrirgl{
  GraphMLReader::GraphMLReader(std::string filename)
    : filename(filename) {
      parse();
      if (!is_valid(g)) {
        throw "Invalid graph";
      }
      assign_outgoing_edges();
    }

  GraphMLReader::GraphMLReader(GraphMLReader::Graph g)
    : g(g) {
      if (!is_valid(g)) {
        throw "Invalid graph";
      }
      assign_outgoing_edges();
    }

  bool GraphMLReader::is_valid(GraphMLReader::Graph g) {
    for (int i = 0; i < g.nodes.size(); i++) {
      if (g.nodes.at(i).id != i) {
        return false;
      }
    }

    for (int i = 0; i < g.edges.size(); i++) {
      if (g.edges.at(i).id != g.nodes.size() + i) {
        return false;
      }

      if (!(0 <= g.edges.at(i).source && g.edges.at(i).source < g.nodes.size())) {
        return false;
      }

      if (!(0 <= g.edges.at(i).target && g.edges.at(i).target < g.nodes.size())) {
        return false;
      }
    }

    return true;
  }

  void GraphMLReader::parse() {
    // http://www.xmlsoft.org/examples/parse2.c
    LIBXML_TEST_VERSION
    xmlParserCtxtPtr ctxt;
    xmlDocPtr doc;
    ctxt = xmlNewParserCtxt();
    if (ctxt == NULL) {
      fprintf(stderr, "Failed to allocate parser context\n");
      return;
    }
    doc = xmlCtxtReadFile(ctxt, filename.c_str(), NULL, XML_PARSE_NOBLANKS);
    if (doc == NULL) {
      fprintf(stderr, "Failed to parse %s\n", filename.c_str());
      return;
    }
    opt<GraphMLReader::Graph> graph(parseGraphML(doc->children));

    if (!graph) {
      fprintf(stderr, "Failed to parse graph\n");
      return;
    }

    g = *graph.get();

    xmlFreeParserCtxt(ctxt);
    xmlCleanupParser();
  }

  void GraphMLReader::assign_outgoing_edges() {
    for (int e = 0; e < g.edges.size(); e++) {
      GraphMLReader::Edge& edge(g.edges.at(e));
      unsigned source = edge.source;
      g.nodes.at(source).outgoing_edges.push_back(&edge);
    }
  }

  void GraphMLReader::setStringMap(std::string property_name, std::string property_value) {
    if (string_map.find(property_name) == string_map.end()) {
      string_map[property_name] = std::map<std::string, int>();
    }

    if (string_map[property_name].find(property_value) == string_map[property_name].end()) {
      int next_id = string_map[property_name].empty() ? 0 : string_map[property_name].size();
      string_map[property_name][property_value] = next_id;
    }
  }

  // TODO: This assumes that the values are all positive.
  void GraphMLReader::setNodeProperties(std::string key, int* arr) {
    for (int n = 0; n < g.nodes.size(); n++) {
      arr[n] = -1;
      for (std::vector<GraphMLReader::Property>::iterator prop = g.nodes.at(n).properties.begin();
          prop != g.nodes.at(n).properties.end();
          prop++) {
        // TODO: Use compare here instead of find.
        if (key.find(prop->getKey()) != std::string::npos) {
          if (prop->getType() == GraphMLReader::INT) {
            arr[n] = *prop->getIntValue().get();

          } else if (prop->getType() == GraphMLReader::STRING) {
            std::string value = *prop->getStringValue().get();
            setStringMap(key, value);
            arr[n] = string_map[key][value];
          }
          break;
        }
      }
      if (arr[n] == -1) {
        fprintf(stderr, "No value for key=%s for node=%d\n", key.c_str(), n);
      }
    }
  }

  int GraphMLReader::mapString(std::string property_name, std::string property_value) {
    return mapString(opt<std::string>(property_name), property_value);
  }

  int GraphMLReader::mapString(std::string property_value) {
    return mapString(opt<std::string>(), property_value);
  }

  int GraphMLReader::mapString(opt<std::string> property_name, std::string property_value) {
    if (property_name) {
      opt<GraphMLReader::Type> type = getPropertyType(*property_name.get(), g.keys);
      if (type && *type.get() == GraphMLReader::STRING) {
        setStringMap(*property_name.get(), property_value);
        return string_map[*property_name.get()][property_value];
      }
    }

    int value;
    int nparsed = sscanf((char*)property_value.c_str(), "%d", &value);
    if (nparsed == 0) {
      fprintf(stderr, "GraphMLReader::mapString: failed to parse int: %s\n", (char*)property_value.c_str());
      throw "Failed to parse query.";
    }
    return value;
  }

  void GraphMLReader::setCSR(unsigned* row_start, unsigned* edge_dst) {
    row_start[0] = 0;
    unsigned ei = 0;

    for (int n = 0; n < g.nodes.size(); n++) {
      GraphMLReader::Node& node(g.nodes.at(n));

      for (std::vector<Edge*>::iterator iter = node.outgoing_edges.begin();
          iter != node.outgoing_edges.end();
          iter++) {
          edge_dst[ei] = (*iter)->target;
          ei = ei + 1;
      }

      row_start[1+n] = ei;
    }
  }

  int GraphMLReader::nnodes() {
    return g.nodes.size();
  }

  int GraphMLReader::nedges() {
    return g.edges.size();
  }

  opt<GraphMLReader::Type> GraphMLReader::getPropertyType(std::string key, std::vector<Key> keys) {
    for (std::vector<GraphMLReader::Key>::iterator iter = keys.begin(); iter != keys.end(); iter++) {
      if (!iter->name.compare(key)) {
        return opt<GraphMLReader::Type>(iter->type);
      }
    }

    return opt<GraphMLReader::Type>();
  }

  opt<GraphMLReader::Property> GraphMLReader::parseProperty(xmlNode* node, std::vector<Key> keys) {
    if (!node) {
      return opt<GraphMLReader::Property>();
    }

    if (xmlStrcmp(node->name, (const xmlChar*)"data")) {
      return opt<GraphMLReader::Property>();
    }

    xmlAttr* attr = node->properties;
    if (!attr) {
      fprintf(stderr, "GraphMLReader::parseProperty: <data> has no attributes.\n");
      return opt<GraphMLReader::Property>();
    }

    if (xmlStrcmp(attr->name, (const xmlChar*)"key")) {
      fprintf(stderr, "GraphMLReader::parseProperty: key is not first attribute.\n");
      return opt<GraphMLReader::Property>();
    }

    if (attr->children->type != XML_TEXT_NODE) {
      fprintf(stderr, "GraphMLReader::parseProperty: value attribute is not of type text.\n");
      return opt<GraphMLReader::Property>();
    }

    xmlChar* xmlKey = xmlNodeGetContent(attr->children);
    if (xmlKey == NULL) {
      fprintf(stderr, "GraphMLReader::parseProperty: key getContent failed.\n");
      return opt<GraphMLReader::Property>();
    }
    std::string key((char*)xmlKey);

    opt<GraphMLReader::Type> optType(getPropertyType(key, keys));
    if (!optType) {
      fprintf(stderr, "GraphMLReader::parseProperty: failed find key for property: %s\n", key.c_str());
      return opt<GraphMLReader::Property>();
    }
    GraphMLReader::Type type(*optType.get());

    xmlChar* content = xmlNodeGetContent(node);
    if (type == GraphMLReader::INT) {
      int value;
      int nparsed = sscanf((char*)content, "%d", &value);
      if (nparsed == 0) {
        fprintf(stderr, "GraphMLReader::parseProperty: failed to parse data: %s\n", (char*)content);
        return opt<GraphMLReader::Property>();
      }
      return opt<Property>(Property(key, value));

    } else if (type == GraphMLReader::STRING) {
      return opt<Property>(Property(key, (char*)content));
    }

    return opt<GraphMLReader::Property>();
  }

  opt<GraphMLReader::Node> GraphMLReader::parseNode(xmlNode* node, std::vector<Key> keys) {
    if (!node) {
      return opt<GraphMLReader::Node>();
    }

    if (xmlStrcmp(node->name, (const xmlChar*)"node")) {
      return opt<GraphMLReader::Node>();
    }

    xmlAttr* attr = node->properties;
    if (!attr) {
      fprintf(stderr, "GraphMLReader::parseNode: <node> has no attributes.\n");
      return opt<GraphMLReader::Node>();
    }

    if (xmlStrcmp(attr->name, (const xmlChar*)"id")) {
      fprintf(stderr, "GraphMLReader::parseNode: id is not first attribute.\n");
      return opt<GraphMLReader::Node>();
    }

    if (attr->children->type != XML_TEXT_NODE) {
      fprintf(stderr, "GraphMLReader::parseNode: value attribute is not of type text.\n");
      return opt<GraphMLReader::Node>();
    }

    xmlChar* ids = xmlNodeGetContent(attr->children);
    if (ids == NULL) {
      fprintf(stderr, "GraphMLReader::parseNode: id getContent failed.\n");
      return opt<GraphMLReader::Node>();
    }

    int id;
    int nparsed = sscanf((char*)ids, "%d", &id);
    if (nparsed == 0) {
      fprintf(stderr, "GraphMLReader::parseNode: failed to parse id: %s\n", (char*)ids);
      return opt<GraphMLReader::Node>();
    }

    std::vector<GraphMLReader::Property> properties;
    xmlNode* child = node->children;
    opt<GraphMLReader::Property> prop = GraphMLReader::parseProperty(child, keys);
    while (prop) {
      properties.push_back(*prop.get());
      child = child->next;
      prop = GraphMLReader::parseProperty(child, keys);
    }

    return opt<GraphMLReader::Node>(GraphMLReader::Node(id, properties));
  }

  opt<GraphMLReader::Edge> GraphMLReader::parseEdge(xmlNode* node, std::vector<Key> keys) {
    if (!node) {
      return opt<GraphMLReader::Edge>();
    }

    if (xmlStrcmp(node->name, (const xmlChar*)"edge")) {
      return opt<GraphMLReader::Edge>();
    }

    int id = -1;
    int source = -1;
    int target = -1;
    for (xmlAttr* attr = node->properties; attr; attr = attr->next) {
      if (attr->children->type != XML_TEXT_NODE) {
        fprintf(stderr, "GraphMLReader::parseEdge: value attribute is not of type text.\n");
        continue;
      }

      xmlChar* vals = xmlNodeGetContent(attr->children);
      if (vals == NULL) {
        fprintf(stderr, "GraphMLReader::parseEdge: getContent failed.\n");
        continue;
      }

      int val;
      int nparsed = sscanf((char*)vals, "%d", &val);
      if (nparsed == 0) {
        fprintf(stderr, "GraphMLReader::parseEdge: failed to parse val: %s\n", (char*)vals);
        continue;
      }

      if (!xmlStrcmp(attr->name, (const xmlChar*)"id")) {
        id = val;
      }

      if (!xmlStrcmp(attr->name, (const xmlChar*)"source")) {
        source = val;
      }

      if (!xmlStrcmp(attr->name, (const xmlChar*)"target")) {
        target = val;
      }
    }

    if (id == -1) {
      fprintf(stderr, "GraphMLReader::parseEdge: id attribute not set for edge\n");
      return opt<GraphMLReader::Edge>();
    }

    if (source == -1) {
      fprintf(stderr, "GraphMLReader::parseEdge: source attribute not set for edge\n");
      return opt<GraphMLReader::Edge>();
    }

    if (target == -1) {
      fprintf(stderr, "GraphMLReader::parseEdge: target attribute not set for edge\n");
      return opt<GraphMLReader::Edge>();
    }

    std::vector<GraphMLReader::Property> properties;
    xmlNode* child = node->children;
    opt<GraphMLReader::Property> prop = GraphMLReader::parseProperty(child, keys);
    while (prop) {
      properties.push_back(*prop.get());
      child = child->next;
      prop = GraphMLReader::parseProperty(child, keys);
    }

    return opt<GraphMLReader::Edge>(GraphMLReader::Edge(id, source, target, properties));
  }

  opt<GraphMLReader::Key> GraphMLReader::parseKey(xmlNode* node) {
    if (!node) {
      return opt<GraphMLReader::Key>();
    }

    opt<std::string> id;
    opt<std::string> what_for;
    opt<std::string> name;
    opt<GraphMLReader::Type> type;
    for (xmlAttr* attr = node->properties; attr; attr = attr->next) {
      if (attr->children->type != XML_TEXT_NODE) {
        fprintf(stderr, "GraphMLReader::parseKey: value attribute is not of type text.\n");
        continue;
      }

      xmlChar* vals = xmlNodeGetContent(attr->children);
      if (vals == NULL) {
        fprintf(stderr, "GraphMLReader::parseKey: getContent failed.\n");
        continue;
      }

      if (!xmlStrcmp(attr->name, (const xmlChar*)"id")) {
        id = opt<std::string>(std::string((char*)vals));
      }

      if (!xmlStrcmp(attr->name, (const xmlChar*)"for")) {
        what_for = opt<std::string>(std::string((char*)vals));
      }

      if (!xmlStrcmp(attr->name, (const xmlChar*)"attr.name")) {
        name = opt<std::string>(std::string((char*)vals));
      }

      if (!xmlStrcmp(attr->name, (const xmlChar*)"attr.type")) {
        if (!xmlStrcmp(vals, (const xmlChar*)"int")) {
          type = opt<GraphMLReader::Type>(GraphMLReader::INT);
        } else if (!xmlStrcmp(vals, (const xmlChar*)"string")) {
          type = opt<GraphMLReader::Type>(GraphMLReader::STRING);
        }
      }
    }

    if (id && what_for && name && type) {
      return opt<GraphMLReader::Key>(GraphMLReader::Key(*id.get(), *what_for.get(), *name.get(), *type.get()));
    }

    return opt<GraphMLReader::Key>();
  }

  opt<GraphMLReader::Graph> GraphMLReader::parseGraph(xmlNode* node, std::vector<Key> keys) {
    if (!node) {
      return opt<GraphMLReader::Graph>();
    }

    if (xmlStrcmp(node->name, (const xmlChar*)"graph")) {
      return opt<GraphMLReader::Graph>();
    }

    std::vector<GraphMLReader::Node> nodes;
    std::vector<GraphMLReader::Edge> edges;
    for (xmlNode* child = node->children; child; child = child->next) {
      if (child && !xmlStrcmp(child->name, (const xmlChar*)"node")) {
        opt<GraphMLReader::Node> node(parseNode(child, keys));
        if (node) {
          nodes.push_back(*node.get());
        }
      }
      if (child && !xmlStrcmp(child->name, (const xmlChar*)"edge")) {
        opt<GraphMLReader::Edge> edge(parseEdge(child, keys));
        // TODO: This seems like it should be if (edge)
        if (node) {
          edges.push_back(*edge.get());
        }
      }
    }

    return opt<GraphMLReader::Graph>(GraphMLReader::Graph(keys, nodes, edges));
  }

  opt<GraphMLReader::Graph> GraphMLReader::parseGraphML(xmlNode* node) {
    if (!node) {
      return opt<GraphMLReader::Graph>();
    }

    if (xmlStrcmp(node->name, (const xmlChar*)"graphml")) {
      return opt<GraphMLReader::Graph>();
    }

    std::vector<GraphMLReader::Key> keys;
    for (xmlNode* child = node->children; child; child = child->next) {
      if (child && !xmlStrcmp(child->name, (const xmlChar*)"key")) {
        opt<GraphMLReader::Key> key(parseKey(child));
        if (key) {
          keys.push_back(*key.get());
        }
      }
    }

    opt<GraphMLReader::Graph> graph;
    for (xmlNode* child = node->children; child; child = child->next) {
      if (child && !xmlStrcmp(child->name, (const xmlChar*)"graph")) {
        return parseGraph(child, keys);
      }
    }

    return graph;
  }
}
