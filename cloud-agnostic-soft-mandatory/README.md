# Cloud-Agnostic Soft-Mandatory Policies

## Overview

This policy set contains policies with **soft-mandatory** enforcement. These policies will block Terraform runs but can be **overridden by authorized users** with proper justification.

## Agent-Based Policy Evaluations

When using Agent-based policy evaluations (the modern approach), Terraform Cloud requires:

1. **All policies in a set must have the same enforcement level**
2. **Enforcement is controlled at two levels:**
   - **Policy level**: Set in `sentinel.hcl` (soft-mandatory/hard-mandatory)
   - **Policy Set level**: "Allow overrides" checkbox in TFC UI

## How Soft-Mandatory Works

### In This Policy Set

All policies are configured with `enforcement_level = "soft-mandatory"` in `sentinel.hcl`.

### In TFC UI Configuration

When attaching this policy set to workspaces in Terraform Cloud:

1. **Enforcement mode**: Set to "Mandatory"
2. **Allow overrides**: ✅ **CHECKED** (this is what makes it "soft")

This combination means:
- ❌ Policies will block runs when they fail
- ✅ Users with override permissions can proceed
- 📝 All overrides are logged for audit purposes

## Current Policies

### require-all-resources-from-pmr

**Purpose**: Enforces modular architecture by requiring all resources to be defined within modules from the Private Module Registry, not directly in the root module.

**Why Soft-Mandatory**:
- Important architectural practice
- May need exceptions for simple test resources
- Legacy code may have direct resources temporarily

**Override Scenarios**:
- Testing/development workspaces
- One-off resources that don't fit module patterns
- Temporary resources during migration

## Configuring in Terraform Cloud

### Step 1: Create Policy Set

1. Navigate to: **Settings → Policy Sets → Create a new policy set**
2. Choose: **Version control workflow**
3. Connect your repository: `terraform-sentinel-policies`
4. Configure:
   - **Name**: `Cloud-Agnostic Soft-Mandatory`
   - **Description**: `Soft-mandatory policies that can be overridden with justification`
   - **VCS branch**: `main`
   - **Path in repository**: `cloud-agnostic-soft-mandatory`

### Step 2: Configure Enforcement

In the policy set settings:

1. **Enforcement mode**: Select "Mandatory"
2. **Allow members of this organization to override failures**: ✅ **CHECK THIS BOX**
   - This is the critical setting that makes it "soft-mandatory"
   - Without this, it behaves like hard-mandatory (no overrides)

### Step 3: Scope to Workspaces

Choose which workspaces should have these policies:
- **All workspaces** - Apply to entire organization
- **Selected workspaces** - Apply to specific workspaces
- **Tagged workspaces** - Apply based on workspace tags

For your demo: Apply to the `it-ops-api-automation` workspace

## Override Workflow

### When a Policy Fails

1. **Run Status**: "Policy Override Required"
2. **User Action**: Click "Override & Continue" button
3. **Required**: Provide justification for override
4. **Result**: Run proceeds to apply phase
5. **Audit Trail**: Override recorded with:
   - Who overrode the policy
   - When it was overridden
   - Justification provided
   - Run details

### Who Can Override

Users must have one of these permissions:
- **Organization owners** (always can override)
- **Team members** with "Manage Policy Overrides" permission

### Best Practices for Overrides

**Good Justifications:**
- "Testing workspace - resource will be refactored to module later"
- "Legacy resource during migration - ticket #123 to modularize"
- "One-time test resource for demo purposes"

**Bad Justifications:**
- "Overriding to save time"
- "Policy is annoying"
- (empty justification)

## Comparison: Advisory vs Soft-Mandatory vs Hard-Mandatory

| Aspect | Advisory | Soft-Mandatory | Hard-Mandatory |
|--------|----------|----------------|----------------|
| **Blocks Run** | ❌ No | ✅ Yes (until override) | ✅ Yes (always) |
| **Override Option** | N/A | ✅ Yes | ❌ No |
| **Override Logged** | N/A | ✅ Yes | N/A |
| **TFC Setting** | Advisory mode | Mandatory + Allow overrides | Mandatory + NO overrides |
| **Use Case** | Learning, guidance | Business rules, architecture | Security, compliance |

## Adding More Policies

To add additional soft-mandatory policies to this set:

1. Ensure the policy file exists in `../cloud-agnostic/`
2. Add to `sentinel.hcl`:

```hcl
policy "your-policy-name" {
    source = "../cloud-agnostic/your-policy-name.sentinel"
    enforcement_level = "soft-mandatory"
}
```

3. **Important**: All policies in this set MUST be `soft-mandatory`
4. Commit and push changes
5. TFC will automatically sync the updated policy set

## Related Documentation

- [TFC Policy Enforcement](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement)
- [Sentinel Policy Sets](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement/manage-policy-sets)
- [Policy Overrides](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement/manage-policy-sets#policy-overrides)
