# Troubleshooting

Common issues and their solutions.

## Error: Configuration Not Found

**Symptom:** `Error: Configuration file not found at ~/.config/example/config.yml`

**Solution:**
1. Run `example-tool --init` to create default configuration
2. Verify file permissions: `ls -la ~/.config/example/config.yml`
3. Check that the path exists: `mkdir -p ~/.config/example`

## Error: Permission Denied

**Symptom:** `Error: Permission denied when accessing resource`

**Solution:**
1. Check current permissions: `example-tool auth status`
2. Authenticate: `example-tool auth login`
3. Verify your role has required permissions

## Performance Issues

**Symptom:** Commands are running slowly

**Solution:**
1. Check system resources: `top` or `Activity Monitor`
2. Enable verbose logging: `example-tool --verbose`
3. Review advanced-usage.md for optimization techniques

## Getting Help

If you can't find a solution:
1. Check the official documentation
2. Review logs: `example-tool logs --tail 50`
3. Search existing issues in the repository
4. Open a new issue with error details and context
