FASTLANE := bundle exec fastlane

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install                Install dependencies"
	@echo "  test                   Run tests"
	@echo "  distribute_firebase    Distribute to Firebase"
	@echo "  distribute_testflight  Distribute to TestFlight"
	@echo "  submit_appstore        Submit to App Store"
	@echo "  gym_development        Build development app"
	@echo "  gym_adhoc              Build adhoc app"
	@echo "  gym_appstore           Build app store app"
	@echo "  scan_development       Run tests with scan"
	@echo "  pilot_appstore         Upload to TestFlight"
	@echo "  deliver_appstore       Deliver to App Store"
	@echo "  bump_patch_version     Bump patch version"
	@echo "  bump_minor_version     Bump minor version"
	@echo "  bump_major_version     Bump major version"
	@echo "  match_all              Match all certificates and profiles"
	@echo "  match_development      Match development certificate and profile"
	@echo "  match_adhoc            Match adhoc certificate and profile"
	@echo "  match_appstore         Match app store certificate and profile"
	@echo "  match_fetch_all        Fetch all certificates and profiles"
	@echo "  match_fetch_development Fetch development certificate and profile"
	@echo "  match_fetch_adhoc      Fetch adhoc certificate and profile"
	@echo "  match_fetch_appstore   Fetch app store certificate and profile"
	@echo "  match_delete_all       Delete all certificates and profiles"
	@echo "  match_delete_development Delete development certificate and profile"
	@echo "  match_delete_adhoc     Delete adhoc certificate and profile"
	@echo "  match_delete_appstore  Delete app store certificate and profile"
	@echo "  register_bundle_id     Register bundle ID in App Store Connect"
	@echo "  register_device        Register device in App Store Connect"

.PHONY: install
install:
	bundle install

.PHONY: test
test: scan_development

.PHONY: distribute_firebase
distribute_firebase:
	$(FASTLANE) distribute_firebase

.PHONY: distribute_testflight
distribute_testflight: pilot_appstore

.PHONY: submit_appstore
submit_appstore: deliver_appstore

.PHONY: gym_development
gym_development:
	$(FASTLANE) gym_development

.PHONY: gym_adhoc
gym_adhoc:
	$(FASTLANE) gym_adhoc

.PHONY: gym_appstore
gym_appstore:
	$(FASTLANE) gym_appstore

.PHONY: scan_development
scan_development:
	$(FASTLANE) scan_development

.PHONY: pilot_appstore
pilot_appstore:
	$(FASTLANE) pilot_appstore

.PHONY: deliver_appstore
deliver_appstore:
	$(FASTLANE) deliver_appstore

.PHONY: bump_patch_version
bump_patch_version:
	$(FASTLANE) bump_patch_version

.PHONY: bump_minor_version
bump_minor_version:
	$(FASTLANE) bump_minor_version

.PHONY: bump_major_version
bump_major_version:
	$(FASTLANE) bump_major_version

.PHONY: match_all
match_all:
	$(FASTLANE) match_development
	$(FASTLANE) match_adhoc
	$(FASTLANE) match_appstore

.PHONY: match_development
match_development:
	$(FASTLANE) match_development

.PHONY: match_adhoc
match_adhoc:
	$(FASTLANE) match_adhoc

.PHONY: match_appstore
match_appstore:
	$(FASTLANE) match_appstore

.PHONY: match_fetch_all
match_fetch_all:
	$(FASTLANE) match_fetch_development
	$(FASTLANE) match_fetch_adhoc
	$(FASTLANE) match_fetch_appstore

.PHONY: match_fetch_development
match_fetch_development:
	$(FASTLANE) match_fetch_development

.PHONY: match_fetch_adhoc
match_fetch_adhoc:
	$(FASTLANE) match_fetch_adhoc

.PHONY: match_fetch_appstore
match_fetch_appstore:
	$(FASTLANE) match_fetch_appstore

.PHONY: match_delete_all
match_delete_all:
	$(FASTLANE) match_delete_development
	$(FASTLANE) match_delete_adhoc
	$(FASTLANE) match_delete_appstore

.PHONY: match_delete_development
match_delete_development:
	$(FASTLANE) match_delete_development

.PHONY: match_delete_adhoc
match_delete_adhoc:
	$(FASTLANE) match_delete_adhoc

.PHONY: match_delete_appstore
match_delete_appstore:
	$(FASTLANE) match_delete_appstore

.PHONY: register_bundle_id
register_bundle_id:
	$(FASTLANE) produce -a $(id) -i

.PHONY: register_device
register_device:
	$(FASTLANE) run register_device name:$(name) udid:$(udid)
	$(MAKE) match_all
