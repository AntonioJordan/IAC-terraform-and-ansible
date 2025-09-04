package helpers

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// Deploy aplica un módulo Terraform y devuelve las opciones usadas
func Deploy(t *testing.T, path string) *terraform.Options {
	t.Helper()
	opts := &terraform.Options{
		TerraformDir: path,
		VarFiles:     []string{"../../../env/us-east-1/dev/terraform.tfvars"},
	}
	terraform.InitAndApply(t, opts)
	return opts
}

// Destroy destruye la infraestructura creada por Deploy
func Destroy(t *testing.T, opts *terraform.Options) {
	t.Helper()
	terraform.Destroy(t, opts)
}

// Output devuelve el valor de un output de Terraform
func Output(t *testing.T, opts *terraform.Options, name string) string {
	t.Helper()
	return terraform.Output(t, opts, name)
}
