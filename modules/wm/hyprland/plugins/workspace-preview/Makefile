CXX = g++
CXXFLAGS = -std=c++23 -shared -fPIC -Wall
INCLUDES = $(shell pkg-config --cflags hyprland pixman-1 libdrm)
LIBS = $(shell pkg-config --libs pixman-1 libdrm)

PLUGIN = workspace-preview.so
SRC = src/main.cpp

all: $(PLUGIN)

$(PLUGIN): $(SRC)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $@ $< $(LIBS)

clean:
	rm -f $(PLUGIN)

install: $(PLUGIN)
	@echo "Load with: hyprctl plugin load $(PWD)/$(PLUGIN)"

test: $(PLUGIN)
	@echo "Starting nested Hyprland session..."
	@echo "In the nested session, run:"
	@echo "  hyprctl plugin load $(PWD)/$(PLUGIN)"
	Hyprland

.PHONY: all clean install test