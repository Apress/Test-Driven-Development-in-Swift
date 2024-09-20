OS := 18.0
DEVICE := iPhone 16
APP_NAME := Albertos

START_FOLDER := 0-start
END_FOLDER := 1-end

DESTINATION := OS=${OS},name=${DEVICE}

SCHEME := ${APP_NAME}
PROJECT := ${APP_NAME}.xcodeproj

define xcodebuild_test
	set -o pipefail && \
	xcodebuild clean test \
	-project $1/${PROJECT} \
	-scheme ${SCHEME} \
	-destination "${DESTINATION}" \
	| xcbeautify
endef

define generate_project
	xcodegen generate --spec $1/project.yml
endef

define run_tests
	$(call generate_project, $1)
	$(call xcodebuild_test, $1)
endef
