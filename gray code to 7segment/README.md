<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>README.md</title>
<style>
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
    line-height: 1.6;
    max-width: 900px;
    margin: 40px auto;
    padding: 0 20px;
    color: #24292f;
    background: #ffffff;
  }
  h1, h2, h3 {
    border-bottom: 1px solid #d0d7de;
    padding-bottom: 0.3em;
    margin-top: 24px;
    margin-bottom: 16px;
  }
  h1 { font-size: 2em; }
  h2 { font-size: 1.5em; }
  h3 { font-size: 1.25em; }
  code {
    font-family: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, monospace;
    background: #f6f8fa;
    padding: 0.2em 0.4em;
    border-radius: 6px;
    font-size: 85%;
  }
  pre {
    background: #f6f8fa;
    padding: 16px;
    overflow: auto;
    border-radius: 6px;
    line-height: 1.45;
  }
  pre code {
    background: transparent;
    padding: 0;
  }
  table {
    border-collapse: collapse;
    width: 100%;
    margin: 16px 0;
  }
  th, td {
    border: 1px solid #d0d7de;
    padding: 8px 12px;
    text-align: left;
  }
  th {
    background: #f6f8fa;
    font-weight: 600;
  }
  ul, ol { padding-left: 2em; }
  .note {
    background: #ddf4ff;
    border-left: 4px solid #0969da;
    padding: 12px 16px;
    margin: 16px 0;
  }
</style>
</head>
<body>

<h1>Gray Code to 7-Segment Display Converter</h1>

<p>A pure Verilog RTL design that converts a 4-bit Gray code input into the corresponding 7-segment display patterns (active-low).</p>

<p>The design is hierarchical and fully synthesizable:</p>
<ul>
  <li><code>gray2binary</code> – converts Gray code to binary</li>
  <li><code>binary2sevenseg</code> – converts binary to 7-segment patterns</li>
  <li><code>gray2sevenseg</code> – top-level module that connects the two stages</li>
</ul>

<hr>

<h2>Project Structure</h2>

<pre><code>gray2sevenseg/
├── gray2binary.v          # Gray → Binary converter (parameterized)
├── binary2sevenseg.v      # Binary → 7-segment decoder
├── gray2sevenseg.v        # Top-level module
├── gray2sevenseg_test.v   # Self-checking testbench
└── README.md              # This file
</code></pre>

<hr>

<h2>Modules Overview</h2>

<h3>1. <code>gray2binary</code></h3>

<p>Parameterized Gray-to-binary converter.</p>

<pre><code>module gray2binary #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] gray_in,
    output [WIDTH-1:0] binary_out
);
</code></pre>

<ul>
  <li>MSB of binary is the same as MSB of Gray.</li>
  <li>Each subsequent bit is produced by XOR of the previous binary bit and the corresponding Gray bit.</li>
  <li>Fully combinatorial and synthesizable using a <code>generate</code> loop.</li>
</ul>

<h3>2. <code>binary2sevenseg</code></h3>

<p>Combinatorial binary-to-7-segment decoder (active-low).</p>

<pre><code>module binary2sevenseg (
    input  [3:0] binary_in,
    output reg [6:0] seg_out
);
</code></pre>

<p>Segment encoding (common anode / active-low):</p>

<table>
  <thead>
    <tr>
      <th>Binary</th>
      <th>Hex</th>
      <th>seg_out (gfedcba)</th>
      <th>Display</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>0000</td><td>0</td><td><code>1000000</code></td><td>0</td></tr>
    <tr><td>0001</td><td>1</td><td><code>1111001</code></td><td>1</td></tr>
    <tr><td>0010</td><td>2</td><td><code>0100100</code></td><td>2</td></tr>
    <tr><td>0011</td><td>3</td><td><code>0110000</code></td><td>3</td></tr>
    <tr><td>0100</td><td>4</td><td><code>0011001</code></td><td>4</td></tr>
    <tr><td>0101</td><td>5</td><td><code>0010010</code></td><td>5</td></tr>
    <tr><td>0110</td><td>6</td><td><code>0000010</code></td><td>6</td></tr>
    <tr><td>0111</td><td>7</td><td><code>1111000</code></td><td>7</td></tr>
    <tr><td>1000</td><td>8</td><td><code>0000000</code></td><td>8</td></tr>
    <tr><td>1001</td><td>9</td><td><code>0010000</code></td><td>9</td></tr>
    <tr><td>1010</td><td>A</td><td><code>0001000</code></td><td>A</td></tr>
    <tr><td>1011</td><td>B</td><td><code>0000011</code></td><td>b</td></tr>
    <tr><td>1100</td><td>C</td><td><code>1000110</code></td><td>C</td></tr>
    <tr><td>1101</td><td>D</td><td><code>0100001</code></td><td>d</td></tr>
    <tr><td>1110</td><td>E</td><td><code>0000110</code></td><td>E</td></tr>
    <tr><td>1111</td><td>F</td><td><code>0001110</code></td><td>F</td></tr>
  </tbody>
</table>

<p>Default case drives all segments off (<code>7'b1111111</code>).</p>

<h3>3. <code>gray2sevenseg</code> (Top-level)</h3>

<pre><code>module gray2sevenseg #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] gray_in,
    output [6:0]       seg_out
);
</code></pre>

<p>Instantiates:</p>
<ol>
  <li><code>gray2binary</code> to convert Gray → Binary</li>
  <li><code>binary2sevenseg</code> to convert Binary → 7-segment</li>
</ol>

<p>Only the lower 4 bits of the binary result are used by the 7-segment decoder (suitable for a single hexadecimal digit).</p>

<hr>

<h2>Testbench</h2>

<p>The self-checking testbench (<code>gray2sevenseg_test.v</code>) applies all 16 possible 4-bit Gray codes in the standard reflected Gray-code order and verifies the expected 7-segment patterns.</p>

<p>Test sequence (Gray → expected binary value → expected segments):</p>

<table>
  <thead>
    <tr>
      <th>Gray</th>
      <th>Binary</th>
      <th>Expected seg_out</th>
    </tr>
  </thead>
  <tbody>
    <tr><td><code>0000</code></td><td>0</td><td><code>1000000</code></td></tr>
    <tr><td><code>0001</code></td><td>1</td><td><code>1111001</code></td></tr>
    <tr><td><code>0011</code></td><td>2</td><td><code>0100100</code></td></tr>
    <tr><td><code>0010</code></td><td>3</td><td><code>0110000</code></td></tr>
    <tr><td><code>0110</code></td><td>4</td><td><code>0011001</code></td></tr>
    <tr><td><code>0111</code></td><td>5</td><td><code>0010010</code></td></tr>
    <tr><td><code>0101</code></td><td>6</td><td><code>0000010</code></td></tr>
    <tr><td><code>0100</code></td><td>7</td><td><code>1111000</code></td></tr>
    <tr><td><code>1100</code></td><td>8</td><td><code>0000000</code></td></tr>
    <tr><td><code>1101</code></td><td>9</td><td><code>0010000</code></td></tr>
    <tr><td><code>1111</code></td><td>A</td><td><code>0001000</code></td></tr>
    <tr><td><code>1110</code></td><td>B</td><td><code>0000011</code></td></tr>
    <tr><td><code>1010</code></td><td>C</td><td><code>1000110</code></td></tr>
    <tr><td><code>1011</code></td><td>D</td><td><code>0100001</code></td></tr>
    <tr><td><code>1001</code></td><td>E</td><td><code>0000110</code></td></tr>
    <tr><td><code>1000</code></td><td>F</td><td><code>0001110</code></td></tr>
  </tbody>
</table>

<p>On success the testbench prints:</p>

<pre><code>==============================
       TEST PASSED
==============================
</code></pre>

<p>On failure it prints the failing vector and stops simulation.</p>

<hr>

<h2>How to Simulate</h2>

<p>Using any IEEE-1364 / SystemVerilog compatible simulator (Icarus Verilog, ModelSim, Vivado, VCS, etc.):</p>

<pre><code># Icarus Verilog example
iverilog -o gray2sevenseg_tb \
    gray2binary.v \
    binary2sevenseg.v \
    gray2sevenseg.v \
    gray2sevenseg_test.v

vvp gray2sevenseg_tb
</code></pre>

<p>Or with a single command:</p>

<pre><code>iverilog -o sim *.v && vvp sim
</code></pre>

<hr>

<h2>Design Notes</h2>

<ul>
  <li><strong>Fully combinatorial</strong> – no clocks or sequential logic.</li>
  <li><strong>Parameterized width</strong> – <code>gray2binary</code> and the top-level module accept a <code>WIDTH</code> parameter (default = 4). The 7-segment decoder is fixed to 4 bits.</li>
  <li><strong>Active-low segments</strong> – suitable for common-anode 7-segment displays.</li>
  <li><strong>Synthesizable</strong> – uses only continuous assignments, generate blocks and a simple case statement.</li>
</ul>

<hr>

<h2>Typical Use Case</h2>

<p>Useful for educational purposes, FPGA demos, or any system that presents a Gray-code counter / rotary encoder value on a hexadecimal 7-segment display.</p>

</body>
</html>