include constants.mk

PROJECTS := 04-tdd-in-the-real-world \
	05-fixtures \
	06-testing-static-swiftui-views \
	07-testing-dynamic-swiftui-views \
	08-stub \
	09-json-decoding \
	10-networking \
	11-dependency-injection-with-environment-object \
	12-spy \
	13-testing-view-presentation \
	14-fixing-bugs-and-changing-code \
	15-fake-and-dummy \
	17-appendix-b-nimble-only \
	18-appendix-b-quick-and-nimble \
	19-appendix-c-uikit

test_all: clean_all
	@for project in ${PROJECTS}; do \
		(cd $$project && make); \
	done

# The DerivedData folders for the projects quickly add up to dozens of GBs
clean_all:
	@find . -type d -name 'DerivedData' | while read dir; do \
		echo "Deleting $$dir..."; \
		rm -rf "$$dir"; \
	done
