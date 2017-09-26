import Vue from "vue/dist/vue.esm"
import App from "./app.vue"

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    el: "#provisioning",
    data: {
      domain: "",
      app: "",
      helps: {
        domain: "example.com",
        app: "app"
      },
      placeholders: {
        domain: "example.com",
        app: "app"
      },
      providers: {
        dns: "digitalocean",
        hosting: "digitalocean",
        platform: "dokku"
      },
      digitalocean: {
        token: ""
      },
      aws: {
        access_key_id: "",
        secret_access_key: ""
      }
    },
    watch: {
      domain: function(value) {
        this.helps.domain = value || placeholders.domain;
      },
      app: function(value) {
        this.helps.app = value || placeholders.app;
      }
    },
    components: { App }
  })
})
