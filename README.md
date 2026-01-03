# MovieMatch

A personalized movie recommendation system built with React and AWS.

## Features

- Genre-based filtering
- Personalized recommendations based on likes/dislikes
- User authentication

## Prerequisites

- Node.js and npm
- AWS account
- Terraform
- TMDB API key

## Setup

### 1. Clone Repository

```bash
git clone https://github.com/austyn06/MovieMatch.git
cd MovieMatch
```

### 2. Install Dependencies

```bash
npm ci
```

### 3. Install AWS Connector for GitHub

Before deploying, install the AWS Connector for GitHub:

1. Go to the [AWS Connector for GitHub](https://github.com/apps/aws-connector-for-github) page
2. Click "Configure" or "Install"
3. Select your GitHub account and grant access to your repository
4. This creates a connection in the AWS Console that Amplify will use

### 4. Create GitHub Personal Access Token (Classic)

**Important:** You must create a Token (classic), NOT a fine-grained token.

1. Go to GitHub: **Settings** -> **Developer settings** -> **Personal access tokens** -> **Tokens (classic)**
2. Click **Generate new token (classic)**
3. Name it (e.g., "AWS Amplify")
4. Select scopes:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `admin:repo_hook` (Full control of repository hooks)
5. Click **Generate token** and copy it immediately

### 5. Create Terraform Variables File

Create a `terraform.tfvars` file in the terraform directory with the following template:

```hcl
region       = "us-east-1"
repository   = "https://github.com/austyn06/MovieMatch"
branch_name  = "main"
access_token = "YOUR_GITHUB_CLASSIC_TOKEN"
tmdb_api_key = "YOUR_TMDB_API_KEY"
```

Replace the placeholder values with your actual configuration.

### 6. Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply
```

After `terraform apply` completes, copy the `amplify_app_url` from the output. Give Amplify 2-3 minutes to build and deploy the application. Alternatively, you can run it locally:

```bash
npm run dev
```

## How It Works

1. Users sign up or log in
3. Select genres to filter results
4. Like/dislike movies to personalize recommendations
5. Algorithm suggests movies based on preferences

## Clean Up

```bash
cd terraform
terraform destroy
```
