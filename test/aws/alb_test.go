package helpers

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// Deploy aplica un módulo Terraform y devuelve las opciones
func Deploy(t *testing.T, path string) *terraform.Options {
	t.Helper()
	opts := &terraform.Options{
		TerraformDir: path,
	}
	terraform.InitAndApply(t, opts)
	return opts
}

// Destroy limpia recursos creados por Deploy
func Destroy(t *testing.T, opts *terraform.Options) {
	t.Helper()
	terraform.Destroy(t, opts)
}

// Output obtiene un valor de output por nombre
func Output(t *testing.T, opts *terraform.Options, name string) string {
	t.Helper()
	return terraform.Output(t, opts, name)
}
