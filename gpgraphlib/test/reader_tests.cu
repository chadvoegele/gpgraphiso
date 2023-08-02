#include <gtest/gtest.h>

#include "graphml.h"

using namespace gpgraphlib;

TEST(graphmlreader, parse_key_test1) {
  const char *document = "<key id=\"k0\" for=\"node\" attr.name=\"name\" attr.type=\"string\"></key>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  opt<GraphMLReader::Key> key = GraphMLReader::parseKey(doc->children);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = key;
  EXPECT_TRUE(actual_valid);

  EXPECT_EQ("k0", key.get()->id);
  EXPECT_EQ("node", key.get()->what_for);
  EXPECT_EQ("name", key.get()->name);
  EXPECT_EQ(GraphMLReader::STRING, key.get()->type);
}

TEST(graphmlreader, parse_property_test1) {
  const char *document = "<data key=\"size\">2</data>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  std::vector<GraphMLReader::Key> keys;
  keys.push_back(GraphMLReader::Key("id", "node", "size", GraphMLReader::INT));
  opt<GraphMLReader::Property> prop = GraphMLReader::parseProperty(doc->children, keys);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = prop;
  EXPECT_TRUE(actual_valid);

  EXPECT_EQ("size", prop.get()->getKey());
  EXPECT_EQ(2, *prop.get()->getIntValue().get());
}

TEST(graphmlreader, parse_property_test2) {
  const char *document = "<data key=\"size\">a</data>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  std::vector<GraphMLReader::Key> keys;
  keys.push_back(GraphMLReader::Key("id", "node", "size", GraphMLReader::INT));
  opt<GraphMLReader::Property> prop = GraphMLReader::parseProperty(doc->children, keys);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = prop;
  EXPECT_FALSE(actual_valid);
}

TEST(graphmlreader, parse_property_test3) {
  const char *document = "<data key=\"shape\">square</data>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  std::vector<GraphMLReader::Key> keys;
  keys.push_back(GraphMLReader::Key("id", "node", "shape", GraphMLReader::STRING));
  opt<GraphMLReader::Property> prop = GraphMLReader::parseProperty(doc->children, keys);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = prop;
  EXPECT_TRUE(actual_valid);

  EXPECT_EQ("shape", prop.get()->getKey());
  EXPECT_EQ("square", *prop.get()->getStringValue().get());
}

TEST(graphmlreader, parse_node_test1) {
  const char *document = "<node id=\"1\"><data key=\"size\">2</data><data key=\"shape\">square</data></node>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  std::vector<GraphMLReader::Key> keys;
  keys.push_back(GraphMLReader::Key("id", "node", "size", GraphMLReader::INT));
  keys.push_back(GraphMLReader::Key("id", "node", "shape", GraphMLReader::STRING));
  opt<GraphMLReader::Node> node = GraphMLReader::parseNode(doc->children, keys);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = node;
  EXPECT_TRUE(actual_valid);

  EXPECT_EQ(1, node.get()->id);
  EXPECT_EQ(2, node.get()->properties.size());
  EXPECT_EQ("size", node.get()->properties.at(0).getKey());
  EXPECT_EQ(2, *node.get()->properties.at(0).getIntValue().get());
  EXPECT_EQ("shape", node.get()->properties.at(1).getKey());
  EXPECT_EQ("square", *node.get()->properties.at(1).getStringValue().get());
}

TEST(graphmlreader, parse_node_test2) {
  const char *document = "<node id=\"2\"></node>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  std::vector<GraphMLReader::Key> keys;
  opt<GraphMLReader::Node> node = GraphMLReader::parseNode(doc->children, keys);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = node;
  EXPECT_TRUE(actual_valid);

  EXPECT_EQ(2, node.get()->id);
  EXPECT_EQ(0, node.get()->properties.size());
}

TEST(graphmlreader, parse_graphml_test1) {
  const char *document = "<graphml><key id=\"id\" for=\"node\" attr.name=\"size\" attr.type=\"int\"/><key id=\"id\" for=\"node\" attr.name=\"shape\" attr.type=\"string\"/><graph><node id=\"1\"><data key=\"size\">6</data><data key=\"shape\">circle</data></node><node id=\"2\"><data key=\"size\">4</data><data key=\"shape\">square</data></node><edge id=\"3\" source=\"1\" target=\"2\"></edge></graph></graphml>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  opt<GraphMLReader::Graph> graph = GraphMLReader::parseGraphML(doc->children);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = graph;
  EXPECT_TRUE(actual_valid);

  EXPECT_EQ(2, graph.get()->nodes.size());

  EXPECT_EQ(1, graph.get()->nodes.at(0).id);
  EXPECT_EQ(2, graph.get()->nodes.at(0).properties.size());

  EXPECT_EQ("size", graph.get()->nodes.at(0).properties.at(0).getKey());
  EXPECT_EQ(6, *graph.get()->nodes.at(0).properties.at(0).getIntValue().get());

  EXPECT_EQ("shape", graph.get()->nodes.at(0).properties.at(1).getKey());
  EXPECT_EQ("circle", *graph.get()->nodes.at(0).properties.at(1).getStringValue().get());

  EXPECT_EQ(2, graph.get()->nodes.at(1).id);
  EXPECT_EQ(2, graph.get()->nodes.at(1).properties.size());

  EXPECT_EQ("size", graph.get()->nodes.at(1).properties.at(0).getKey());
  EXPECT_EQ(4, *graph.get()->nodes.at(1).properties.at(0).getIntValue().get());

  EXPECT_EQ("shape", graph.get()->nodes.at(1).properties.at(1).getKey());
  EXPECT_EQ("square", *graph.get()->nodes.at(1).properties.at(1).getStringValue().get());
}

TEST(graphmlreader, parse_graphml_test2) {
  const char *document = "<graphml><key id=\"id\" for=\"node\" attr.name=\"size\" attr.type=\"int\"/><key id=\"id\" for=\"node\" attr.name=\"shape\" attr.type=\"string\"/><graph><node id=\"1\"><data key=\"size\">6</data><data key=\"shape\">triangle</data></node><node id=\"2\"><data key=\"size\">4</data><data key=\"shape\">triangle</data></node><edge id=\"3\" source=\"1\" target=\"2\"><data key=\"size\">8</data><data key=\"shape\">square</data></edge><edge id=\"4\" source=\"2\" target=\"2\"><data key=\"size\">5</data><data key=\"shape\">circle</data></edge></graph></graphml>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  opt<GraphMLReader::Graph> graph = GraphMLReader::parseGraphML(doc->children);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = graph;
  EXPECT_TRUE(actual_valid);

  EXPECT_EQ(2, graph.get()->nodes.size());

  EXPECT_EQ(1, graph.get()->nodes.at(0).id);
  EXPECT_EQ(2, graph.get()->nodes.at(0).properties.size());

  EXPECT_EQ("size", graph.get()->nodes.at(0).properties.at(0).getKey());
  EXPECT_EQ(6, *graph.get()->nodes.at(0).properties.at(0).getIntValue().get());

  EXPECT_EQ("shape", graph.get()->nodes.at(0).properties.at(1).getKey());
  EXPECT_EQ("triangle", *graph.get()->nodes.at(0).properties.at(1).getStringValue().get());

  EXPECT_EQ(2, graph.get()->nodes.at(1).id);
  EXPECT_EQ(2, graph.get()->nodes.at(1).properties.size());

  EXPECT_EQ("size", graph.get()->nodes.at(1).properties.at(0).getKey());
  EXPECT_EQ(4, *graph.get()->nodes.at(1).properties.at(0).getIntValue().get());

  EXPECT_EQ("shape", graph.get()->nodes.at(1).properties.at(1).getKey());
  EXPECT_EQ("triangle", *graph.get()->nodes.at(1).properties.at(1).getStringValue().get());

  EXPECT_EQ(2, graph.get()->edges.size());

  EXPECT_EQ(3, graph.get()->edges.at(0).id);
  EXPECT_EQ(1, graph.get()->edges.at(0).source);
  EXPECT_EQ(2, graph.get()->edges.at(0).target);
  EXPECT_EQ(2, graph.get()->edges.at(0).properties.size());
  EXPECT_EQ("size", graph.get()->edges.at(0).properties.at(0).getKey());
  EXPECT_EQ(8, *graph.get()->edges.at(0).properties.at(0).getIntValue().get());
  EXPECT_EQ("shape", graph.get()->edges.at(0).properties.at(1).getKey());
  EXPECT_EQ("square", *graph.get()->edges.at(0).properties.at(1).getStringValue().get());

  EXPECT_EQ(4, graph.get()->edges.at(1).id);
  EXPECT_EQ(2, graph.get()->edges.at(1).source);
  EXPECT_EQ(2, graph.get()->edges.at(1).target);
  EXPECT_EQ(2, graph.get()->edges.at(1).properties.size());
  EXPECT_EQ("size", graph.get()->edges.at(1).properties.at(0).getKey());
  EXPECT_EQ(5, *graph.get()->edges.at(1).properties.at(0).getIntValue().get());
  EXPECT_EQ("shape", graph.get()->edges.at(1).properties.at(1).getKey());
  EXPECT_EQ("circle", *graph.get()->edges.at(1).properties.at(1).getStringValue().get());
}

TEST(graphmlreader, is_valid_test1) {
  std::vector<GraphMLReader::Key> k;
  std::vector<GraphMLReader::Node> n;
  std::vector<GraphMLReader::Edge> e;
  GraphMLReader::Graph graph(k, n, e);
  EXPECT_TRUE(GraphMLReader::is_valid(graph));
}

TEST(graphmlreader, is_valid_test2) {
  std::vector<GraphMLReader::Key> ks;
  std::vector<GraphMLReader::Node> ns;
  std::vector<GraphMLReader::Property> ps;
  ns.push_back(GraphMLReader::Node(0, ps));
  ns.push_back(GraphMLReader::Node(2, ps));
  std::vector<GraphMLReader::Edge> es;
  GraphMLReader::Graph graph(ks, ns, es);
  EXPECT_FALSE(GraphMLReader::is_valid(graph));
}

TEST(graphmlreader, is_valid_test3) {
  std::vector<GraphMLReader::Key> ks;
  std::vector<GraphMLReader::Node> ns;
  std::vector<GraphMLReader::Property> ps;
  ns.push_back(GraphMLReader::Node(0, ps));
  ns.push_back(GraphMLReader::Node(1, ps));
  std::vector<GraphMLReader::Edge> es;
  es.push_back(GraphMLReader::Edge(2, 0, 1, ps));
  es.push_back(GraphMLReader::Edge(3, 1, 0, ps));
  GraphMLReader::Graph graph(ks, ns, es);
  EXPECT_TRUE(GraphMLReader::is_valid(graph));
}

TEST(graphmlreader, is_valid_test4) {
  std::vector<GraphMLReader::Key> ks;
  std::vector<GraphMLReader::Node> ns;
  std::vector<GraphMLReader::Property> ps;
  ns.push_back(GraphMLReader::Node(0, ps));
  ns.push_back(GraphMLReader::Node(1, ps));
  std::vector<GraphMLReader::Edge> es;
  es.push_back(GraphMLReader::Edge(2, 2, 1, ps));
  es.push_back(GraphMLReader::Edge(3, 1, 0, ps));
  GraphMLReader::Graph graph(ks, ns, es);
  EXPECT_FALSE(GraphMLReader::is_valid(graph));
}

TEST(graphmlreader, is_valid_test5) {
  std::vector<GraphMLReader::Key> ks;
  std::vector<GraphMLReader::Node> ns;
  std::vector<GraphMLReader::Property> ps;
  ns.push_back(GraphMLReader::Node(0, ps));
  ns.push_back(GraphMLReader::Node(1, ps));
  std::vector<GraphMLReader::Edge> es;
  es.push_back(GraphMLReader::Edge(2, 0, 1, ps));
  es.push_back(GraphMLReader::Edge(4, 1, 0, ps));
  GraphMLReader::Graph graph(ks, ns, es);
  EXPECT_FALSE(GraphMLReader::is_valid(graph));
}

TEST(graphmlreader, set_node_properties_test1) {
  std::vector<GraphMLReader::Property> p0s;
  p0s.push_back(GraphMLReader::Property("size", 5));
  p0s.push_back(GraphMLReader::Property("shape", "circle"));

  std::vector<GraphMLReader::Property> p1s;
  p1s.push_back(GraphMLReader::Property("size", 1));
  p1s.push_back(GraphMLReader::Property("shape", "square"));

  std::vector<GraphMLReader::Key> ks;
  ks.push_back(GraphMLReader::Key("id", "node", "size", GraphMLReader::INT));
  ks.push_back(GraphMLReader::Key("id", "node", "shape", GraphMLReader::STRING));

  std::vector<GraphMLReader::Node> ns;
  ns.push_back(GraphMLReader::Node(0, p0s));
  ns.push_back(GraphMLReader::Node(1, p1s));

  std::vector<GraphMLReader::Edge> es;
  GraphMLReader::Graph graph(ks, ns, es);
  GraphMLReader gr(graph);
  EXPECT_TRUE(GraphMLReader::is_valid(graph));

  int sizes[2];
  gr.setNodeProperties("size", sizes);
  EXPECT_EQ(5, sizes[0]);
  EXPECT_EQ(1, sizes[1]);

  int shapes[2];
  gr.setNodeProperties("shape", shapes);
  EXPECT_EQ(0, shapes[0]);
  EXPECT_EQ(1, shapes[1]);
  EXPECT_EQ(0, gr.mapString("shape", "circle"));
  EXPECT_EQ(1, gr.mapString("shape", "square"));
}

TEST(graphmlreader, set_csr_test_1) {
  std::vector<GraphMLReader::Key> ks;

  std::vector<GraphMLReader::Property> ps;
  std::vector<GraphMLReader::Node> ns;
  ns.push_back(GraphMLReader::Node(0, ps));
  ns.push_back(GraphMLReader::Node(1, ps));
  ns.push_back(GraphMLReader::Node(2, ps));

  std::vector<GraphMLReader::Edge> es;
  es.push_back(GraphMLReader::Edge(3, 0, 1, ps));
  es.push_back(GraphMLReader::Edge(4, 1, 0, ps));
  es.push_back(GraphMLReader::Edge(5, 1, 2, ps));
  es.push_back(GraphMLReader::Edge(6, 2, 0, ps));

  GraphMLReader::Graph graph(ks, ns, es);
  GraphMLReader gr(graph);
  EXPECT_TRUE(GraphMLReader::is_valid(graph));

  unsigned row_start[3];
  unsigned edge_dst[4];
  gr.setCSR(row_start, edge_dst);
  EXPECT_EQ(0, row_start[0]);
  EXPECT_EQ(1, row_start[1]);
  EXPECT_EQ(3, row_start[2]);

  EXPECT_EQ(1, edge_dst[0]);
  EXPECT_EQ(0, edge_dst[1]);
  EXPECT_EQ(2, edge_dst[2]);
  EXPECT_EQ(0, edge_dst[3]);
}

TEST(graphmlreader, nnodes_test1) {
  std::vector<GraphMLReader::Key> ks;
  std::vector<GraphMLReader::Node> ns;
  std::vector<GraphMLReader::Property> ps;
  ns.push_back(GraphMLReader::Node(0, ps));
  ns.push_back(GraphMLReader::Node(1, ps));
  std::vector<GraphMLReader::Edge> es;
  GraphMLReader::Graph graph(ks, ns, es);
  GraphMLReader gr(graph);
  EXPECT_EQ(2, gr.nnodes());
}

TEST(graphmlreader, nedges_test1) {
  std::vector<GraphMLReader::Key> ks;
  std::vector<GraphMLReader::Node> ns;
  std::vector<GraphMLReader::Property> ps;
  ns.push_back(GraphMLReader::Node(0, ps));
  ns.push_back(GraphMLReader::Node(1, ps));
  std::vector<GraphMLReader::Edge> es;
  es.push_back(GraphMLReader::Edge(2, 0, 1, ps));
  es.push_back(GraphMLReader::Edge(3, 1, 0, ps));
  es.push_back(GraphMLReader::Edge(4, 1, 1, ps));
  GraphMLReader::Graph graph(ks, ns, es);
  GraphMLReader gr(graph);
  EXPECT_EQ(3, gr.nedges());
}

TEST(graphmlreader, parse_edge_test1) {
  const char *document = "<edge id=\"3\" source=\"1\" target=\"2\"><data key=\"size\">2</data><data key=\"shape\">circle</data></edge>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  std::vector<GraphMLReader::Key> ks;
  ks.push_back(GraphMLReader::Key("id", "node", "size", GraphMLReader::INT));
  ks.push_back(GraphMLReader::Key("id", "node", "shape", GraphMLReader::STRING));
  opt<GraphMLReader::Edge> edge = GraphMLReader::parseEdge(doc->children, ks);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = edge;
  EXPECT_TRUE(actual_valid);

  EXPECT_EQ(3, edge.get()->id);
  EXPECT_EQ(1, edge.get()->source);
  EXPECT_EQ(2, edge.get()->target);
  EXPECT_EQ(2, edge.get()->properties.size());
  EXPECT_EQ("size", edge.get()->properties.at(0).getKey());
  EXPECT_EQ(2, *edge.get()->properties.at(0).getIntValue().get());
  EXPECT_EQ("shape", edge.get()->properties.at(1).getKey());
  EXPECT_EQ("circle", *edge.get()->properties.at(1).getStringValue().get());
}

TEST(graphmlreader, parse_edge_test2) {
  const char *document = "<edge id=\"3\"></edge>";
  LIBXML_TEST_VERSION
  xmlDocPtr doc;
  doc = xmlReadMemory(document, strlen(document), "noname.xml", NULL, 0);
  std::vector<GraphMLReader::Key> ks;
  opt<GraphMLReader::Edge> edge = GraphMLReader::parseEdge(doc->children, ks);
  xmlFreeDoc(doc);
  xmlCleanupParser();

  bool actual_valid = edge;
  EXPECT_FALSE(actual_valid);
}
