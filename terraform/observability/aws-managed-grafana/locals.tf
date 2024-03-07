locals {
  name           = "aws-observability-accelerator"
  description    = "Amazon Managed Grafana workspace for ${local.name}"
  sts_caller_arn = data.aws_caller_identity.current.account_id
  eks_oidc_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}"
  oidc_arn       = replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")

  tags = module.tags.tags
}