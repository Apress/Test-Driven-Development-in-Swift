DESTINATION := OS=17.5,name=iPhone 15

test_end:
	xcodegen generate
	set -o pipefail && \
		xcodebuild clean test \
		-project Albertos.xcodeproj \
		-scheme Albertos \
		-destination "${DESTINATION}" \
		| xcbeautify

