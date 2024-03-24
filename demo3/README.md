# Simple CICD Pipeline

このリポジトリには以下のリソースをデプロイするための Terraform コードが含まれています。

- 本番環境(prod)と開発環境(dev)の VCL サービス
- 証明書

ディレクトリレイアウトは以下の通りです。

```
├── .github
│   └── workflows
│       ├── cleanup.yml
│       ├── deploy_cert.yml
│       ├── deploy_dev.yml
│       ├── deploy_prod.yml
│       └── run_terraform.yml
├── cert
│   ├── .terraform.lock.hcl
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── dev
│   ├── .terraform.lock.hcl
│   ├── html
│   │   └── custom_404.html
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── vcl
│       ├── error_custom_404.vcl
│       ├── fetch_custom_404.vcl
│       └── main.vcl
└── prod
    ├── .terraform.lock.hcl
    ├── main.tf
    ├── output.tf
    ├── provider.tf
    ├── terraform.tfvars
    ├── variables.tf
    └── vcl
        └── main.vcl
```

## Github Actions ワークフロー

ワークフローは main ブランチに対する `push`, `pull_request`, `workflow_dispatch` をトリガとして実行されます。

- **Pull Requests**

  - `terraform plan` の実行
  - PR に `terraform plan` の結果を追加する ([こちらのページ](https://learn.hashicorp.com/tutorials/terraform/github-actions)のテンプレートを利用しました)。

- **Push/Merge**

  - `terraform apply` の実行

- **Workflow dispatch**

  - **Deploy Cert/Prod/Stage workflow**

    - `plan` か `apply` を選択して実行

  - **Cleanup workflow**

    - ワーキングディレクトリを選択して `terraform destroy` を実行

## 環境変数

ワークフローを実行するために必用な環境変数です。各変数がリポジトリからアクセス可能な Secret として登録されている必用があります。

| Var Name              | Description                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------------- |
| AWS_ACCESS_KEY_ID     |                                                                                             |
| AWS_SECRET_ACCESS_KEY |                                                                                             |
| BACKEND_BUCKET        | S3 bucket の名前, リモートバックエンドの Output 変数 `bucket` の値をセットする              |
| BACKEND_DYNAMO_DB     | DynamoDB table の名前, リモートバックエンドの Output 変数 `dynamodb_table` の値をセットする |
| BACKEND_ROLE_ARN      | Role ARN, リモートバックエンドの Output 変数 `role_arn` の値をセットする                    |
| FASTLY_API_KEY        | [Fastly API token](https://docs.fastly.com/en/guides/using-api-tokens?_fsi=fmEGPI4g)        |

## リモートバックエンド

この例では State ファイルを格納するリモートバックエンドとして S3 を使用しています。

以下のコードは Terraform Module を使ってバックエンドのコンポーネントとなる S3 bucket と DynamoDB table をデプロイするためのものです。リモートバックエンドはこのリポジトリで管理する Fastly サービス・証明書とは別にデプロイします。

```
provider "aws" {
    region = "ap-northeast-1"
}

module "s3backend" {
  source  = "terraform-in-action/s3backend/aws"
  version = "0.1.10"
}

output "config" {
  value = module.s3backend
}
```

> [!NOTE]
> 使用している Terraform Module は `Terraform in Action` という書籍で紹介されていたものです。
> https://registry.terraform.io/modules/terraform-in-action/s3backend/aws/latest

### S3 バックエンドデプロイ時のアウトプットの例

`bucket`, `dynamodb_table`, `role_arn` の値をそれぞれ対応する環境変数にセットします。

```
s3backend_config = {
    bucket         = "s3backend-XXXXX-state-bucket"
    dynamodb_table = "s3backend-XXXXX-state-lock"
    region         = "ap-northeast-1"
    role_arn       = "arn:aws:iam::YYYYY:role/s3backend-XXXXX-tf-assume-role"
}
```
