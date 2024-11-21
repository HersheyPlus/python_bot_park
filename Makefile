.PHONY: load-env

GREEN = \033[32m
RESET = \033[0m

load-env:
	python3 -m venv venv
	. venv/bin/activate && pip3 install -r requirements.txt
	@echo "-> Environment loaded"
	@echo "-> Run $(GREEN)'source venv/bin/activate'$(RESET) to activate the environment"
