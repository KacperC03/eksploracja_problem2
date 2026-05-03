# Makefile for fp-growth project

# Compiler
CXX = g++

# Flagi kompilatora
CXXFLAGS = -std=c++17 -Wall -O3

# Pliki źródłowe i docelowe dla lokalnych testów
TEST_SRC = main.cpp
TEST_TARGET = fp-growth.exe

# Używamy Pythona do pobrania ścieżek i od razu zamieniamy '\' na '/' dla MinGW
PYBIND_INCLUDES = $(shell python -c "import pybind11, sysconfig; print(f'-I\"{sysconfig.get_path(\"include\").replace(\"\\\\\", \"/\")}\" -I\"{pybind11.get_include().replace(\"\\\\\", \"/\")}\"')")

PY_LDFLAGS = $(shell python -c "import sys, os; p = os.path.join(sys.base_prefix, 'libs').replace('\\\\', '/'); print(f'-L\"{p}\" -lpython{sys.version_info.major}{sys.version_info.minor}')")

PY_EXT = .pyd
WRAPPER_SRC = wrapper.cpp
WRAPPER_TARGET = fpgrowth_fast$(PY_EXT)

# Default target
all: test python_module

test: $(TEST_SRC)
	$(CXX) $(CXXFLAGS) $(TEST_SRC) -o $(TEST_TARGET)

# Dodaliśmy $(PY_LDFLAGS) na samym końcu tego polecenia!
python_module: $(WRAPPER_SRC)
	$(CXX) $(CXXFLAGS) -shared -static -fPIC $(PYBIND_INCLUDES) $(WRAPPER_SRC) -o $(WRAPPER_TARGET) $(PY_LDFLAGS)

# Clean target
clean:
	rm -f $(TEST_TARGET) $(WRAPPER_TARGET) *.o

# Phony targets
.PHONY: all test python_module clean