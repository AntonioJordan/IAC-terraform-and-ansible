package test

import (
	"testing"
	"time"

	"github.com/AntonioJordan/IAC-terraform-and-ansible/test/helpers"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
)

func TestAlb(t *testing.T) {
	t.Parallel()

	// Deploy ALB module
	opts := helpers.Deploy(t, "../../terraform/modules/aws/alb")
	defer helpers.Destroy(t, opts)

	// Get ALB DNS name
	albDns := helpers.Output(t, opts, "alb_dns_name")

	// Validate ALB responds HTTP 200
	http_helper.HttpGetWithRetry(
		t,
		"http://"+albDns,
		nil,
		200,
		"",
		30,
		5*time.Second,
	)
}
