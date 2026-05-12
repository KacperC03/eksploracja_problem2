# Makefile for fp-growth project

# Compiler
CXX = g++

# Flagi kompilatora
CXXFLAGS = -std=c++17 -Wall -O3

# Pliki źródłowe i docelowe dla lokalnych testów
TEST_SRC = main.cpp
TEST_TARGET = fp-growth.exe

PY_EXT = .pyd
WRAPPER_SRC = wrapper.cpp
WRAPPER_TARGET = fpgrowth_fast$(PY_EXT)

# Default target
all: test python_module

test: $(TEST_SRC)
	$(CXX) $(CXXFLAGS) $(TEST_SRC) -o $(TEST_TARGET)

# Python module - próbuje setup.py, a jeśli zawiedzie (np. brak MSVC), używa build_module.py
python_module: $(WRAPPER_SRC)
	@./venv/Scripts/python.exe setup.py build_ext --inplace 2>/dev/null || (echo "setup.py nie powiodl sie, proba build_module.py (g++)..." && ./venv/Scripts/python.exe build_module.py)

# Clean target
clean:
	del /f /q $(TEST_TARGET) $(WRAPPER_TARGET) *.o 2>nul || true

# Phony targets
.PHONY: all test python_module clean