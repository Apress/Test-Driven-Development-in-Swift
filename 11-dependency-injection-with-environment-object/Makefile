DESTINATION := OS=17.5,name=iPhone 15

test: test_start test_end

test_start:
	xcodegen generate --spec ./0-start/project.yml
	set -o pipefail && \
		xcodebuild clean test \
		-project ./0-start/Albertos.xcodeproj \
		-scheme Albertos \
		-destination "${DESTINATION}" \
		| xcbeautify

test_end:
	xcodegen generate --spec ./1-end/project.yml
	set -o pipefail && \
		xcodebuild clean test \
		-project ./1-end/Albertos.xcodeproj \
		-scheme Albertos \
		-destination "${DESTINATION}" \
		| xcbeautify

