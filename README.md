# IaC Development Container
IaC development environment containerized with Docker. It contains the folowing tools and features:
- [Terraform](https://www.terraform.io/)
- [Terraform CDK (TypeScript)](https://developer.hashicorp.com/terraform/tutorials/cdktf)
- [Ansible](https://www.ansible.com/)
- [OpenNebula CLI](https://docs.opennebula.io/6.4/management_and_operations/references/cli.html)

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[![CC BY-SA 4.0][cc-by-sa-shield]][cc-by-sa]

Containerized development environment for Infrastructure as Code (IaC) projects.

```
cd dev-container-example
docker-compose up -d
docker exec -it IaCDevContainer bash
```

---

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg
