.PHONY: verify fix lint format type-check install test test-cov integration-local docs docs-serve

# Verify - check everything without making changes
verify: lint format-check type-check

# Fix - automatically fix what can be fixed
fix:
	uvx ruff check --fix .
	uvx ruff format .

# Individual targets
lint:
	uvx ruff check .

format-check:
	uvx ruff format --check .

format:
	uvx ruff format .

type-check:
	uvx ty check

# Install dependencies
install:
	uv sync --all-groups

# Run tests
test:
	uv run pytest tests/ -v

# Run tests with coverage reports (terminal + XML + HTML)
test-cov:
	uv run pytest tests/ -v --cov=extensions --cov=tests --cov-report=term-missing --cov-report=xml:coverage.xml --cov-report=html:htmlcov

# Render the template, build Docker image, and run Nextflow smoke test locally
integration-local:
	set -eu; \
	output_dir="$$(mktemp -d)"; \
	echo "Rendering integration project to $$output_dir"; \
	uv run copier copy . "$$output_dir" --vcs-ref HEAD --defaults --force --trust \
		-d project_name="Integration Project" \
		-d project_description="Integration smoke test" \
		-d project_slug="integration_project" \
		-d author_name="Local CI" \
		-d author_email="local-ci@example.com" \
		-d github_username="testuser" \
		-d repository_name="integration-project" \
		-d project_type="hybrid_python_nextflow" \
		-d include_nextflow=true \
		-d include_docker=true \
		-d container_strategy="full_pipeline_image" \
		-d include_docs=false \
		-d include_github_actions=false \
		-d include_prek=false \
		-d include_bio_defaults=true \
		-d nextflow_default_profile="local" \
		-d nextflow_config_style="single_nextflow_config"; \
	docker build -t integration-project:local-ci "$$output_dir"; \
	nf_cmd="docker run --rm -u $$(id -u):$$(id -g) -v $$output_dir:/workspace -w /workspace --entrypoint nextflow integration-project:local-ci"; \
	nf_run_extra=""; \
	echo "Using nextflow from integration-project:local-ci image"; \
	eval "$$nf_cmd -version" | grep -q "version 25.10.4"; \
	cd "$$output_dir"; \
	eval "$$nf_cmd config -profile local"; \
	eval "NXF_SYNTAX_PARSER=v2 $$nf_cmd lint ."; \
	eval "$$nf_cmd run main.nf -profile test,local $$nf_run_extra --input 'data/test/*.csv' --outdir results-ci"; \
	ls results-ci/pipeline_info/trace_*.txt >/dev/null; \
	ls results-ci/pipeline_info/report_*.html >/dev/null; \
	ls results-ci/pipeline_info/timeline_*.html >/dev/null; \
	echo "Integration smoke test passed in $$output_dir"

# Documentation
docs:
	uv run --group docs mkdocs build

docs-serve:
	uv run --group docs mkdocs serve

# Secret scanning
secrets:
	gitleaks detect --redact 80

# Dependency audit
pysentry:
	uv run pysentry-rs
