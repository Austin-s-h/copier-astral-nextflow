# Template Options

When you run `copier copy`, you'll be prompted for the following options.

## Interactive Prompts

### Project Basics

| Prompt | Type | Default | Description |
|--------|------|---------|-------------|
| `project_name` | string | — | Human-readable project name |
| `project_description` | string | `"A Python package"` | Short project description |
| `project_slug` | string | *derived from name* | Python package name (used for imports) |

### Author Information

| Prompt | Type | Default | Description |
|--------|------|---------|-------------|
| `author_name` | string | *from git config* | Author's full name |
| `author_email` | string | *from git config* | Author's email address |
| `github_username` | string | *auto-detected* | GitHub username or organization |
| `repository_name` | string | *derived from name* | Repository name on GitHub |

### Python Version

| Prompt | Type | Default | Description |
|--------|------|---------|-------------|
| `python_version` | choice | `3.12` | Minimum Python version (`3.10`–`3.13`) |
| `python_versions_matrix` | string | `"3.10,3.11,3.12,3.13"` | Python versions for CI matrix testing |

### Features

| Prompt | Type | Default | Description |
|--------|------|---------|-------------|
| `project_type` | choice | `hybrid_python_nextflow` | Project archetype (`python_package` or `hybrid_python_nextflow`) |
| `include_nextflow` | bool | `true` for hybrid archetype | Include Nextflow DSL2 scaffold |
| `include_cli` | bool | `true` | Include CLI with Typer |
| `include_github_actions` | bool | `true` | Include GitHub Actions CI/CD |
| `include_docker` | bool | `true` | Include Dockerfile for containerization |
| `container_strategy` | choice | `full_pipeline_image` when Nextflow enabled | Container mode (`python_runtime` or `full_pipeline_image`) |
| `nextflow_config_style` | choice | `single_nextflow_config` | Nextflow config layout (`single_nextflow_config` or `split_conf_include_config`) |
| `nextflow_default_profile` | choice | `local` | Default Nextflow runtime profile (`local`, `docker`, `conda`, `apptainer`, or `awsbatch`) |
| `include_aws_batch` | bool | `false` | Include generated AWS Batch execution profile scaffolding |
| `aws_region` | string | `us-east-1` | AWS region for Batch and ECR (when AWS Batch is enabled) |
| `aws_batch_job_queue` | string | `nextflow-batch-queue` | AWS Batch queue name for Nextflow jobs |
| `aws_batch_work_dir` | string | `s3://my-nextflow-bucket/work` | S3 work directory for Nextflow AWS Batch runs |
| `ecr_registry` | string | `123456789012.dkr.ecr.us-east-1.amazonaws.com` | Private ECR registry URI |
| `ecr_repository` | string | repository name | Private ECR repository name |
| `ecr_image_tag` | string | `latest` | Default private ECR image tag |
| `include_bio_defaults` | bool | `true` | Include light bioinformatics defaults/placeholders |
| `include_docs` | bool | `true` | Include MkDocs documentation |
| `include_prek` | bool | `true` | Include prek hooks |
| `include_codecov` | bool | `true` | Include Codecov integration (requires GitHub Actions) |
| `include_security_scanning` | bool | `true` | Include security scanning with Gitleaks, pysentry, and Semgrep (requires GitHub Actions) |
| `include_pypi_publish` | bool | `true` | Include automatic PyPI publishing (requires GitHub Actions) |
| `include_ghcr_release` | bool | `true` when Docker + Nextflow | Include GHCR container publish in release workflow |
| `include_ecr_release` | bool | `true` when Docker + AWS Batch | Include private ECR container publish in release workflow |

### Nextflow Cloud Extension Notes

- Generated Nextflow configs target Nextflow 25 by default.
- `apptainer` is used instead of `singularity` in generated profiles.
- When `include_aws_batch=true`, templates generate a concrete `awsbatch` profile with S3 work dir, queue, region, and private ECR image settings.
- Release workflow can publish directly to private ECR using OIDC with `AWS_ROLE_TO_ASSUME` secret.

### License

| Prompt | Type | Default | Description |
|--------|------|---------|-------------|
| `license` | choice | `MIT` | Project license: MIT, Apache-2.0, GPL-3.0, BSD-3-Clause, ISC, or Proprietary |