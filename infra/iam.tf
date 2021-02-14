resource "google_project_iam_member" "ssh_via_iap" {

  for_each = toset(local.iap_tunnel_users)

  role   = "roles/iap.tunnelResourceAccessor"
  member = "user:${each.key}"
}
