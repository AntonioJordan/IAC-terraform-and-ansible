package helpers

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// AssertNotEmpty checks that a string is not empty
func AssertNotEmpty(t *testing.T, value string, msg string) {
	t.Helper()
	assert.NotEmpty(t, value, msg)
}

// AssertEqualString checks equality between two strings
func AssertEqualString(t *testing.T, expected, actual, msg string) {
	t.Helper()
	assert.Equal(t, expected, actual, msg)
}

// AssertEqualInt checks equality between two integers
func AssertEqualInt(t *testing.T, expected, actual int, msg string) {
	t.Helper()
	assert.Equal(t, expected, actual, msg)
}
