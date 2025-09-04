package test

import (
	"testing"

	"github.com/AntonioJordan/IAC-terraform-and-ansible/test/helpers"
)

func TestEksModule(t *testing.T) {
	t.Parallel()

	// Deploy EKS module
	opts := helpers.Deploy(t, "../../terraform/modules/aws/eks")
	defer helpers.Destroy(t, opts)

	// --- Cluster ---
	clusterName := helpers.Output(t, opts, "cluster_name")
	status := helpers.GetEksClusterStatus(t, clusterName)
	helpers.AssertEqualString(t, "ACTIVE", status, "EKS cluster should be ACTIVE")

	// --- KMS Key ---
	keyId := helpers.Output(t, opts, "kms_key_id")
	keyStatus := helpers.GetKmsKeyStatus(t, keyId)
	helpers.AssertEqualString(t, "Enabled", keyStatus, "KMS key should be enabled")

}
