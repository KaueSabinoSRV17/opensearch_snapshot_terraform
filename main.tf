module "snapshots" {
  source = "./modules/snapshots/"

  bucket_name = var.bucket_name
  account_id  = var.account_id
  region      = var.region
  domain_name = var.domain_name
  user_name   = var.user_name
}
