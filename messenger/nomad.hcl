job "messenger" {
  region =      "global"
  datacenters = ["dc1"]
  type =        "service"

  update {
    # The update stanza specifies the group's update strategy.
    max_parallel =     1
    health_check =     "checks"
    min_healthy_time = "30s"
  }

 group "messenger" {
    #count = INSTANCE_COUNT
    count = 2

    restart {
      delay = "15s"
      mode =  "delay"
    }

    task "messenger" {
      driver = "docker"

      # Configuration is specific to each driver.
      config {
        image =      "bmd007/messenger:latest"
        force_pull = true
        auth {
          username = "bmd007"
          password = ""
        }

        port_map {
          http =  8081
        }
      }

      env {
        #todo add kafka and rabbitMq addresses
        SPRING_PROFILES_ACTIVE =                                  "nomad"
        CONFIG_SERVER_IP =                                        "http://config-center"
        CONFIG_SERVER_PORT =                                      "8888"
        SPRING_CLOUD_CONSUL_HOST =                                "${NOMAD_IP_http}"
        #        SPRING_APPLICATION_INSTANCE_ID =                           "${NOMAD_ALLOC_ID}"
        SPRING_CLOUD_SERVICE_REGISTRY_AUTO_REGISTRATION_ENABLED = "false"
        JAVA_OPTS =                                               "-XshowSettings:vm -XX:+ExitOnOutOfMemoryError -Xmx200m -Xms150m -XX:MaxDirectMemorySize=48m -XX:ReservedCodeCacheSize=64m -XX:MaxMetaspaceSize=128m -Xss256k"
      }
      resources {
        cpu =    256
        memory = 250
        network {
          mbits = 1
          port "http" {}
        }
      }
    }
  }
}
