package test

import (
	"testing"

	"github.com/AntonioJordan/IAC-terraform-and-ansible/test/helpers"
)

func TestVpcModule(t *testing.T) {
	t.Parallel()

	// Deploy VPC module
	opts := helpers.Deploy(t, "../../terraform/modules/aws/vpc")
	defer helpers.Destroy(t, opts)

	// --- VPC ---
	vpcId := helpers.Output(t, opts, "vpc_id")
	vpcs := helpers.GetVpcById(t, vpcId)
	helpers.AssertNotEmpty(t, vpcs[0], "VPC should exist")

	// --- Subnets ---
	publicSubnets := helpers.Output(t, opts, "public_subnet_ids")
	helpers.AssertNotEmpty(t, publicSubnets, "Public subnets should exist")

	privateSubnets := helpers.Output(t, opts, "private_subnet_ids")
	helpers.AssertNotEmpty(t, privateSubnets, "Private subnets should exist")

	// --- NAT Gateways ---
	natGateways := helpers.Output(t, opts, "nat_gateway_ids")
	helpers.AssertNotEmpty(t, natGateways, "NAT gateways should exist")

	// --- VPC Endpoints ---
	vpcEndpoints := helpers.Output(t, opts, "vpc_endpoints")
	helpers.AssertNotEmpty(t, vpcEndpoints, "VPC endpoints should exist")

}
