#
# Important directories
#
INPUT_DIR  = $(PWD)/input
WORK_DIR   = $(PWD)/work
OUTPUT_DIR = $(PWD)/output
STAMPS_DIR = $(PWD)/stamps

#
# Data file (format id;src;dir;dst;fmt;...)
#
DATA_FILE  = $(PWD)/sifry.csv
DATA_SEP   = ,

#
# Tools
#
LAYOUT  = $(PWD)/layout-single.sh
PROCESS = $(PWD)/process-single.sh

#
# Compose useful variables
#
ID_NAME      = $(basename $(notdir $(wildcard $(INPUT_DIR)/$(ID)-*.pdf)))
INPUT_FILES  = $(wildcard $(INPUT_DIR)/*.pdf)
INPUT_NAMES  = $(basename $(notdir $(INPUT_FILES)))
OUTPUT_FILES = $(addsuffix -rep.pdf,$(addprefix $(OUTPUT_DIR)/,$(INPUT_NAMES)))
STAMP_DEPS   = $(filter-out %inner.tex,$(wildcard $(STAMPS_DIR)/*.tex))

#
# General rules
#
.PHONY: all clean cleansingle cleanall

ifeq ($(ID),)
all: $(OUTPUT_FILES)
clean: cleanall
.SECONDARY: $(addsuffix -stamped.pdf,$(addprefix $(WORK_DIR)/,$(INPUT_NAMES)))
else
all: $(OUTPUT_DIR)/$(ID_NAME)-rep.pdf
clean: cleansingle
.SECONDARY: $(WORK_DIR)/$(ID_NAME)-stamped.pdf
endif

cleansingle:
	rm -f $(OUTPUT_DIR)/$(ID_NAME)-rep.pdf
	rm -f $(OUTPUT_DIR)/$(ID_NAME)-rep-nup.pdf
	rm -f $(WORK_DIR)/$(ID_NAME)-stamped.pdf

cleanall:
	rm -f $(OUTPUT_DIR)/*
	rm -f $(WORK_DIR)/*


#
# Actual executive rules
#

# The recipe uses while loop just because of how 'read' obtains its input.
$(WORK_DIR)/%-stamped.pdf: $(INPUT_DIR)/%.pdf \
    $(DATA_FILE) $(STAMP_DEPS)
	ID=`echo "$*" | sed s/-.*$$//` ; \
	grep "^$$ID$(DATA_SEP)" $(DATA_FILE) | while IFS="$(DATA_SEP)" read id src dir dst fmt rest ; do \
	$(PROCESS) "$<" "$@" $$src $$dir $$fmt ; \
	done

$(OUTPUT_DIR)/%-rep.pdf $(OUTPUT_DIR)/%-rep-nup.pdf: \
    $(WORK_DIR)/%-stamped.pdf
	$(LAYOUT) "$<" "$@"

