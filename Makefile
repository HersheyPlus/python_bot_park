.PHONY: load-env

load-env:
	python3 -m venv venv
	. venv/bin/activate && pip3 install -r requirements.txt
	@echo "Virtual environment set up! Activate it using 'source venv/bin/activate'."
