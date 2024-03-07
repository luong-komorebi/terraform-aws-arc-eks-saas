region              = "us-east-1"
environment         = "dev"
namespace           = "arc-saas"
min_pods            = 1
max_pods            = 9
common_name         = "arc-saas.net" #domain name supplied as commn name.
organization        = "Sourcefuse, Inc."
alb_ingress_name    = "alb-external-ingress"
acm_certificate_arn = "arn:aws:acm:us-east-1:471112653618:certificate/906cb286-116b-492b-bd7d-3a5f440deb1f"
full_domain_name    = "*.arc-saas.net" #should always start with wildcard
