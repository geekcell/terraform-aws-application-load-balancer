package test

import (
	"os"
	"testing"

	TTAWS "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/stretchr/testify/assert"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/elbv2"
)

func TestTerraformALBBasicExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic-example",
	})

	// 	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	arn := terraform.Output(t, terraformOptions, "arn")
	assert.NotEmpty(t, arn)

	arn_suffix := terraform.Output(t, terraformOptions, "arn_suffix")
	assert.NotEmpty(t, arn_suffix)

	dns_name := terraform.Output(t, terraformOptions, "dns_name")
	assert.NotEmpty(t, dns_name)

	sess, err := NewSession(os.Getenv("AWS_DEFAULT_REGION"))
	assert.NoError(t, err)

	lbClient := elbv2.New(sess)
	ec2Client := ec2.New(sess)

	input := &elbv2.DescribeLoadBalancersInput{LoadBalancerArns: []*string{&arn}}
	output, err := lbClient.DescribeLoadBalancers(input)
	assert.NoError(t, err)

	assert.Equal(t, 1, len(output.LoadBalancers))
	assert.Equal(t, 2, len(output.LoadBalancers[0].AvailabilityZones))
	assert.Equal(t, 1, len(output.LoadBalancers[0].SecurityGroups))

	lInput := &elbv2.DescribeListenersInput{LoadBalancerArn: &arn}
	lOutput, err := lbClient.DescribeListeners(lInput)
	assert.NoError(t, err)

	assert.Equal(t, 1, len(lOutput.Listeners))
	assert.Equal(t, int64(80), aws.Int64Value(lOutput.Listeners[0].Port))
	assert.Equal(t, "HTTP", aws.StringValue(lOutput.Listeners[0].Protocol))
	assert.Equal(t, 1, len(lOutput.Listeners[0].DefaultActions))
	assert.Equal(t, "443", aws.StringValue(lOutput.Listeners[0].DefaultActions[0].RedirectConfig.Port))

	sgInput := ec2.DescribeSecurityGroupsInput{GroupIds: []*string{output.LoadBalancers[0].SecurityGroups[0]}}
	sgOutput, err := ec2Client.DescribeSecurityGroups(&sgInput)
	assert.NoError(t, err)

	assert.Equal(t, 1, len(sgOutput.SecurityGroups))
	assert.Equal(t, 2, len(sgOutput.SecurityGroups[0].IpPermissions))
	assert.Equal(t, 0, len(sgOutput.SecurityGroups[0].IpPermissionsEgress))

	assert.Equal(t, int64(80), aws.Int64Value(sgOutput.SecurityGroups[0].IpPermissions[0].FromPort))
	assert.Equal(t, "0.0.0.0/0", aws.StringValue(sgOutput.SecurityGroups[0].IpPermissions[0].IpRanges[0].CidrIp))

	assert.Equal(t, int64(443), aws.Int64Value(sgOutput.SecurityGroups[0].IpPermissions[1].FromPort))
	assert.Equal(t, "0.0.0.0/0", aws.StringValue(sgOutput.SecurityGroups[0].IpPermissions[1].IpRanges[0].CidrIp))
}

func NewSession(region string) (*session.Session, error) {
	sess, err := TTAWS.NewAuthenticatedSession(region)
	if err != nil {
		return nil, err
	}

	return sess, nil
}
