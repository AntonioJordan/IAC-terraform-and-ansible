
go mod init github.com/AntonioJordan/IAC-terraform-and-ansible

go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/aws/aws-sdk-go-v2/config
go get github.com/aws/aws-sdk-go-v2/service/s3
go get github.com/aws/aws-sdk-go-v2/service/eks
go get github.com/aws/aws-sdk-go-v2/service/ec2
go get github.com/aws/aws-sdk-go-v2/service/iam
go get github.com/aws/aws-sdk-go-v2/service/kms
go get github.com/stretchr/testify/assert
go get github.com/stretchr/testify@latest

go mod tidy
