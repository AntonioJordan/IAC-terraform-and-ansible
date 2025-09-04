package helpers

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/eks"
	"github.com/aws/aws-sdk-go-v2/service/iam"
	"github.com/aws/aws-sdk-go-v2/service/kms"
)

func loadCfg(t *testing.T) aws.Config {
	t.Helper()
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		t.Fatalf("Error cargando configuración AWS: %v", err)
	}
	return cfg
}

// EKS
func GetEksClusterStatus(t *testing.T, clusterName string) string {
	cfg := loadCfg(t)
	client := eks.NewFromConfig(cfg)
	ctx := context.TODO()
	resp, err := client.DescribeCluster(ctx, &eks.DescribeClusterInput{Name: &clusterName})
	if err != nil {
		t.Fatalf("Error consultando cluster %s: %v", clusterName, err)
	}
	return string(resp.Cluster.Status)
}

// VPC
func GetVpcById(t *testing.T, vpcId string) []string {
	cfg := loadCfg(t)
	client := ec2.NewFromConfig(cfg)
	ctx := context.TODO()
	resp, err := client.DescribeVpcs(ctx, &ec2.DescribeVpcsInput{VpcIds: []string{vpcId}})
	if err != nil {
		t.Fatalf("Error consultando VPC %s: %v", vpcId, err)
	}
	ids := []string{}
	for _, vpc := range resp.Vpcs {
		ids = append(ids, *vpc.VpcId)
	}
	return ids
}

// SG
func GetSecurityGroupById(t *testing.T, sgId string) []string {
	cfg := loadCfg(t)
	client := ec2.NewFromConfig(cfg)
	ctx := context.TODO()
	resp, err := client.DescribeSecurityGroups(ctx, &ec2.DescribeSecurityGroupsInput{GroupIds: []string{sgId}})
	if err != nil {
		t.Fatalf("Error consultando SG %s: %v", sgId, err)
	}
	ids := []string{}
	for _, sg := range resp.SecurityGroups {
		ids = append(ids, *sg.GroupId)
	}
	return ids
}

// IAM
func GetIamRole(t *testing.T, roleName string) string {
	cfg := loadCfg(t)
	client := iam.NewFromConfig(cfg)
	ctx := context.TODO()
	resp, err := client.GetRole(ctx, &iam.GetRoleInput{RoleName: &roleName})
	if err != nil {
		t.Fatalf("Error consultando IAM Role %s: %v", roleName, err)
	}
	return *resp.Role.Arn
}

// KMS
func GetKmsKeyStatus(t *testing.T, keyId string) string {
	cfg := loadCfg(t)
	client := kms.NewFromConfig(cfg)
	ctx := context.TODO()
	resp, err := client.DescribeKey(ctx, &kms.DescribeKeyInput{KeyId: &keyId})
	if err != nil {
		t.Fatalf("Error consultando KMS Key %s: %v", keyId, err)
	}
	return string(resp.KeyMetadata.KeyState)
}
