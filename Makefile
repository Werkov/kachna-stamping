#
# Important directories
#
INPUT_DIR  = $(PWD)/input
WORK_DIR   = $(PWD)/work
OUTPUT_DIR = $(PWD)/output
STAMPS_DIR = $(PWD)/stamps

#
# Data file (format id;num;name;[format])
#
DATA_FILE  = $(PWD)/sifry.csv

#
# Tools
#
LAYOUT  = $(PWD)/layout-single.sh
PROCESS = $(PWD)/process-single.sh

#
# Compose useful variables
#
BASENAME = $(basename $(notdir $(wildcard $(INPUT_DIR)/$(ID)-*.pdf)))

STAMP_DEPS = $(wildcard $(STAMPS_DIR)/*.tex)

#
# General rules
#
.PHONY: single clean
.SECONDARY: $(WORK_DIR)/$(BASENAME)-stamped.pdf

single: $(OUTPUT_DIR)/$(BASENAME)-rep.pdf
clean:
	rm -f $(OUTPUT_DIR)/$(BASENAME)-rep.pdf
	rm -f $(OUTPUT_DIR)/$(BASENAME)-rep-nup.pdf
	rm -f $(WORK_DIR)/$(BASENAME)-stamped.pdf


#
# Actual executive rules
#

# The recipe uses while loop just because of how 'read' obtains its input.
$(WORK_DIR)/$(BASENAME)-stamped.pdf: $(INPUT_DIR)/$(BASENAME).pdf \
    $(DATA_FILE) $(STAMP_DEPS)
	grep "^$(ID);" $(DATA_FILE) | while IFS=";" read id num name format ; do \
	$(PROCESS) "$<" "$@" $$num $$name $$format ; \
	done

$(OUTPUT_DIR)/$(BASENAME)-rep.pdf $(OUTPUT_DIR)/$(BASENAME)-rep-nup.pdf: \
    $(WORK_DIR)/$(BASENAME)-stamped.pdf
	$(LAYOUT) "$<" "$@"

