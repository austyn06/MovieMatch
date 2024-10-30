# Team 7 - Movie Recommendation App

This project is a movie recommendation app built with React and Terraform.

## Prerequisites

- Node.js and npm installed
- Terraform installed
- GitHub token (for creating Amplify resources in AWS)

### Run React App Locally

1. Clone the repository:

   ```bash
   git clone https://github.com/SWEN-514-FALL-2024/term-project-team7.git
   ```

2. Intall dependencies:

   ```bash
   npm ci
   ```

3. Start the app:

   ```bash
   npm run dev
   ```

### Deploy with Terraform

1. Navigate to the `terraform` directory:

   ```bash
   cd terraform
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review resources that will be created:

   ```bash
   terraform plan
   ```

4. Apply the Terraform configuration:
   ```bash
   terraform apply -var="github_token=<YOUR_GITHUB_TOKEN>"
   ```

### Clean Up Resources

1. Run the destroy command in the terraform directory:

   ```bash
   terraform destroy -var="github_token=<YOUR_GITHUB_TOKEN>"
   ```
