provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
    }
  }
}

resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller" 
  namespace  = "kube-system"
  values = [<<EOF
clusterName: ${module.eks.cluster_id}
region: ${var.aws_region}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: ${module.irsa_aws_load_balancer_controller.iam_role_arn}
EOF
  ]

 }