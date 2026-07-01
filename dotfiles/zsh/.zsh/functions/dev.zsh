# Kill-port
kill-port() {
  lsof -i tcp:$1 | awk 'NR!=1 {print $2}' | xargs kill -9
}

# Run a specific vitest test until it fails
# Usage: vitest-flaky path/to/test.spec.ts [test name pattern]

function vitest-flaky() {
  local test_file="$1"
  local test_name="$2"
  local max_runs=500
  local batch_size=5
  local total_batches=$((max_runs / batch_size))
  local batch=1

  if [[ -z "$test_file" ]]; then
    echo "Usage: vitest-flaky \"test name pattern\" [test name pattern]"
    echo "Example: vitest-flaky \"useSpinner > with hash\""
    return 1
  fi

  echo "Running test: $test_file"
  [[ -n "$test_name" ]] && echo "Test name pattern: $test_name"
  echo "Max runs: $max_runs (batch size: $batch_size)"
  echo ""

  local vitest_cmd=(npx vitest run "$test_file")
  [[ -n "$test_name" ]] && vitest_cmd+=(--testNamePattern="$test_name")

  while ((batch <= total_batches)); do
    local run_start=$(((batch - 1) * batch_size + 1))
    local run_end=$((batch * batch_size))
    echo -n "Batch $batch (runs $run_start–$run_end): "

    local pids=()
    local tmp_files=()
    for i in {1..$batch_size}; do
      local tmp_output=$(mktemp)
      tmp_files+=("$tmp_output")
      (
        APP_PORT=0 "${vitest_cmd[@]}" 2>&1 >"$tmp_output"
        echo $? >"${tmp_output}.exit"
      ) &
      pids+=($!)
    done

    local failed_idx=0
    for i in {1..$batch_size}; do
      wait $pids[$i]
    done
    for i in {1..$batch_size}; do
      if [[ $(cat "${tmp_files[$i]}.exit") != "0" ]]; then
        failed_idx=$i
        break
      fi
    done

    if ((failed_idx > 0)); then
      local failed_run=$((run_start + failed_idx - 1))
      echo "✗ FAIL (run $failed_run)"
      echo ""
      echo "========================================"
      echo "FAILED ON RUN $failed_run - FULL OUTPUT:"
      echo "========================================"
      cat "$tmp_files[$failed_idx]"
      echo ""
      echo "========================================"
      for f in $tmp_files; do
        rm -f "$f" "${f}.exit"
      done
      return 1
    fi

    echo "✓ PASS"
    for f in $tmp_files; do
      rm -f "$f" "${f}.exit"
    done
    ((batch++))
  done

  echo ""
  echo "Reached max runs ($max_runs) without failure. Test appears stable."
  return 0
}
