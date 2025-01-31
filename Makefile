CXX       = g++
CXXFLAGS  = -std=c++20 -Wall -Wextra -Iinclude -I/opt/homebrew/opt/googletest/include -MMD -MP
LDFLAGS   = -L/opt/homebrew/opt/googletest/lib
LDLIBS    = -lgtest -lgtest_main -pthread

TARGET_DIR = bin
TARGET    = $(TARGET_DIR)/test

SRC       = src/StringUtils.cpp
TESTSRC   = testsrc/StringUtilsTest.cpp

OBJ       = $(addprefix $(TARGET_DIR)/,$(notdir $(SRC:.cpp=.o)))
TESTOBJ   = $(addprefix $(TARGET_DIR)/,$(notdir $(TESTSRC:.cpp=.o)))
DEPFILES  = $(OBJ:.o=.d) $(TESTOBJ:.o=.d)

.PHONY: all clean test

all: $(TARGET)

$(TARGET_DIR):
	mkdir -p $(TARGET_DIR)

$(TARGET): $(OBJ) $(TESTOBJ) | $(TARGET_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBS)

$(TARGET_DIR)/%.o: src/%.cpp | $(TARGET_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET_DIR)/%.o: testsrc/%.cpp | $(TARGET_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

-include $(DEPFILES)

test: $(TARGET)
	./$(TARGET)

clean:
	rm -rf $(TARGET_DIR)