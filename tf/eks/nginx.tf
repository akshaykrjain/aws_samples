resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "terraform-nginx"
    labels = {
      test = "MyNginxApp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "MyNginxApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyNginxApp"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
