CXX = g++
CXXFLAGS = -std=c++23 -shared -fPIC -Wall
INCLUDES = $(shell pkg-config --cflags hyprland pixman-1 libdrm)
LIBS = $(shell pkg-config --libs pixman-1 libdrm)

PLUGIN = workspace-preview.so
PLUGIN_V2 = workspace-preview-v2.so
PLUGIN_V3 = workspace-preview-v3.so
SRC = src/main.cpp
SRC_V2 = src/main-v2.cpp
SRC_V3 = src/main-v3.cpp

all: $(PLUGIN)

$(PLUGIN): $(SRC)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $@ $< $(LIBS)

v2: $(PLUGIN_V2)

$(PLUGIN_V2): $(SRC_V2)
	$(CXX) $(CXXFLAGS) $(INCLUDES) \
		$(shell pkg-config --cflags jsoncpp) \
		-o $@ $< $(LIBS) \
		$(shell pkg-config --libs jsoncpp)

v3: $(PLUGIN_V3)

$(PLUGIN_V3): $(SRC_V3)
	$(CXX) $(CXXFLAGS) $(INCLUDES) \
		$(shell pkg-config --cflags jsoncpp libpng) \
		-o $@ $< $(LIBS) \
		$(shell pkg-config --libs jsoncpp libpng) \
		-lGL

clean:
	rm -f $(PLUGIN) $(PLUGIN_V2) $(PLUGIN_V3)

install: $(PLUGIN)
	@echo "Load with: hyprctl plugin load $(PWD)/$(PLUGIN)"

test: $(PLUGIN)
	@echo "Starting nested Hyprland session..."
	@echo "In the nested session, run:"
	@echo "  hyprctl plugin load $(PWD)/$(PLUGIN)"
	Hyprland

test-v3: $(PLUGIN_V3)
	@echo "Starting nested Hyprland session..."
	@echo "In the nested session, run:"
	@echo "  hyprctl plugin load $(PWD)/$(PLUGIN_V3)"
	Hyprland

.PHONY: all clean install test v2 v3 test-v3