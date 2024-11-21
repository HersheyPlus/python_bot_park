
.PHONY: load-env

load-env :
	python3 -m venv venv
	. venv/bin/activate && pip install -r requirements.txt
	source venv/bin/activate
