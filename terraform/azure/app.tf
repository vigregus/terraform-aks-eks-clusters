resource "helm_release" "app" {
  name       = "app"
  chart      = "../../k8s/app"  
             
  set {
    name  = "namespace.name"
    value = "${var.namespace}"
  }

  set {
    name  = "hosts.app"
    value = "${var.host-name}"
  }
  set {
    name = "replicas.count"
    value = "${var.replicas-count}"
  }
  set {
    name  = "image.repository"
    value = "${var.image_repository}"
  }
  set {
    name  = "image.tag"
    value = "${var.image_tag}"
  }

}

