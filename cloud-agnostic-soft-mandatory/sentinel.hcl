# Soft-Mandatory Policy Set
#
# This policy set contains policies that should block runs but can be overridden
# by authorized users. When using Agent-based policy evaluations, all policies
# in this set must have the same enforcement level.
#
# In TFC UI, configure this policy set with:
#   - Enforcement mode: Mandatory
#   - Allow overrides: YES (checked)

# Import common functions from parent directory
module "tfplan-functions" {
    source = "../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
    source = "../common-functions/tfstate-functions/tfstate-functions.sentinel"
}

module "tfconfig-functions" {
    source = "../common-functions/tfconfig-functions/tfconfig-functions.sentinel"
}

module "tfrun-functions" {
    source = "../common-functions/tfrun-functions/tfrun-functions.sentinel"
}

# Policy: Require all resources to come from modules in PMR
# This enforces a modular architecture where the root module only calls modules
policy "require-all-resources-from-pmr" {
    source = "../cloud-agnostic/require-all-resources-from-pmr.sentinel"
    enforcement_level = "mandatory"
}

# Add additional policies here that should be soft-mandatory
# Examples:
# - Cost control policies (can be exceeded with justification)
# - Naming convention policies (exceptions for legacy resources)
# - Module source policies (exceptions for one-off resources)
