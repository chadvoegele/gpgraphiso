#pragma once

#include <string>
#include <vector>
#include <map>
#include <libxml/parser.h>
#include <libxml/tree.h>

#include <stdio.h>

namespace cgrirgl {
  template<typename T>
  class opt {
    public:
      opt() : valid(false), d() { }
      opt(T d) : valid(true), d(d) { }
      operator bool() { return valid; }
      T* get() { return &d; }

    private:
      bool valid;
      T d;
  };

  class GraphMLReader {
    public:
      enum Type { INT, STRING };

      class Property {
        public:
          Property() : key(), ivalue(), svalue() {}
          Property(std::string key, int value) : key(key), type(INT), ivalue(value) { }
          Property(std::string key, std::string value) : key(key), type(STRING), svalue(value) { }
          std::string getKey() { return key; }
          Type getType() { return type; }
          opt<int> getIntValue() {  return ivalue; }
          opt<std::string> getStringValue() { return svalue; }

        private:
          std::string key;
          Type type;
          opt<int> ivalue;
          opt<std::string> svalue;
      };

      class Edge {
        public:
          Edge() : id(), source(), target(), properties() {}
          Edge(int id, int source, int target, std::vector<Property> properties)
            : id(id), source(source), target(target), properties(properties) {}
          int id, source, target;
          std::vector<Property> properties;
      };

      class Node {
        public:
          Node() : id(), properties(), outgoing_edges() {}
          Node(int id, std::vector<Property> properties) : id(id), properties(properties), outgoing_edges() {}
          int id;
          std::vector<Property> properties;
          std::vector<Edge*> outgoing_edges;
      };

      class Key {
        public:
          Key() : id(), what_for(), name(), type() { }
          Key(std::string id, std::string what_for, std::string name, Type type) :
            id(id), what_for(what_for), name(name), type(type) { }
          std::string id;
          std::string what_for;
          std::string name;
          Type type;
      };

      class Graph {
        public:
          Graph() : keys(), nodes(), edges() {}
          Graph(std::vector<Key> keys, std::vector<Node> nodes, std::vector<Edge> edges)
            : keys(keys), nodes(nodes), edges(edges) {}
          std::vector<Key> keys;
          std::vector<Node> nodes;
          std::vector<Edge> edges;
      };

      GraphMLReader(std::string filename);
      GraphMLReader(Graph g);
      void setNodeProperties(std::string key, int* arr);
      void setCSR(unsigned* row_start, unsigned* edge_dst);
      int mapString(std::string property_name, std::string property_value);
      int mapString(std::string property_value);
      int nnodes();
      int nedges();

      static opt<Type> getPropertyType(std::string key, std::vector<Key> keys);
      static opt<Property> parseProperty(xmlNode* node, std::vector<Key> keys);
      static opt<Node> parseNode(xmlNode* node, std::vector<Key> keys);
      static opt<Edge> parseEdge(xmlNode* node, std::vector<Key> keys);
      static opt<Key> parseKey(xmlNode* node);
      static opt<Graph> parseGraph(xmlNode* node, std::vector<Key> keys);
      static opt<Graph> parseGraphML(xmlNode* node);
      static bool is_valid(Graph g);

    private:
      void parse();
      void assign_outgoing_edges();
      void setStringMap(std::string property_name, std::string property_value);
      int mapString(opt<std::string> property_name, std::string property_value);
      std::string filename;
      Graph g;
      std::map<std::string, std::map<std::string, int> > string_map;
  };
}
