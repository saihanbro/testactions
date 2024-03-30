define BG # background
  $(shell echo -e "\033[46m") 
endef

define FG # foreground
  $(shell echo -e "\033[30m")
endef

define RESET # back to default output
  $(shell echo -e "\033[0m")
endef

.PHONY: test clean

.venv:
	@echo -e "$(FG)$(BG)Creating Virtual Environment.......$(RESET)"
	python -m venv .venv

install_dev: .venv
	@echo -e "$(FG)$(BG)Installing Dependencies.......$(RESET)"
	.venv/bin/python -m pip install --upgrade pip			
	.venv/bin/pip install torch==2.2.2+cpu -f https://download.pytorch.org/whl/torch_stable.html
	.venv/bin/pip install -r requirements.txt
	.venv/bin/pip install -r requirements_dev.txt
	.venv/bin/pre-commit install

test: .venv
	@echo -e "$(FG)$(BG)Testing the Package.......$(RESET)"
	.venv/bin/coverage run -m pytest
	
black: .venv
	@echo -e "$(FG)$(BG)Running Black.......$(RESET)"
	.venv/bin/black torchmate/ --config=pyproject.toml --check

flake8: .venv
	@echo -e "$(FG)$(BG)Running Flake8 Test.......$(RESET)"
	.venv/bin/flake8 torchmate --config=.flake8

clean:
	@echo -e "$(FG)$(BG)Cleaning Caches.......$(RESET)"
	rm -rf .pytest_cache __pycache__ torchmate.egg-info .coverage
	rm -rf $(shell find torchmate/  -name "__pycache__" -type d)
	rm -rf $(shell find tests/  -name ".pytest_cache" -type d)
	rm -rf $(shell find tests/  -name ".coverage" -type f)
	rm -rf build dist
	rm -rf htmlcov


all: clean black flake8 test