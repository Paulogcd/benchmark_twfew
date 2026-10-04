const DATA = window.BENCHMARK_DATA;

let rankingChart = null;
let runsChart = null;


/* ---------------------------------------------------------
   Utilities
--------------------------------------------------------- */

function valuesFor(result) {
    return result.measurements
        .map(x => Number(x.elapsed_seconds))
        .filter(Number.isFinite);
}


function mean(values) {
    if (!values.length) return NaN;

    return values.reduce((a, b) => a + b, 0) / values.length;
}


function median(values) {
    if (!values.length) return NaN;

    const sorted = [...values].sort((a, b) => a - b);
    const middle = Math.floor(sorted.length / 2);

    if (sorted.length % 2 === 0) {
        return (sorted[middle - 1] + sorted[middle]) / 2;
    }

    return sorted[middle];
}


function standardDeviation(values) {
    if (values.length < 2) return 0;

    const avg = mean(values);

    const variance =
        values.reduce(
            (sum, value) => sum + (value - avg) ** 2,
            0
        ) / values.length;

    return Math.sqrt(variance);
}


function formatSeconds(value) {
    if (!Number.isFinite(value)) return "—";

    if (value < 0.001) {
        return `${(value * 1e6).toFixed(1)} μs`;
    }

    if (value < 1) {
        return `${value.toFixed(3)} s`;
    }

    return `${value.toFixed(2)} s`;
}


function escapeHtml(value) {
    return String(value)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}


/* ---------------------------------------------------------
   Aggregate data
--------------------------------------------------------- */

function getFilteredResults() {
    const benchmark =
        document.getElementById("benchmarkFilter").value;

    const pkg =
        document.getElementById("packageFilter").value;

    return DATA.results.filter(result => {

        const benchmarkMatches =
            benchmark === "all" ||
            result.benchmark === benchmark;

        const packageMatches =
            pkg === "all" ||
            result.package === pkg;

        return benchmarkMatches && packageMatches;
    });
}


function aggregate(results) {

    const groups = new Map();

    for (const result of results) {

        const key = result.package;

        if (!groups.has(key)) {
            groups.set(key, []);
        }

        groups.get(key).push(
            ...valuesFor(result)
        );
    }

    return [...groups.entries()]
        .map(([packageName, values]) => {

            const sorted = [...values].sort(
                (a, b) => a - b
            );

            return {
                package: packageName,
                values,

                mean: mean(values),
                median: median(values),
                min: Math.min(...values),
                max: Math.max(...values),
                stddev: standardDeviation(values),

                count: values.length
            };
        })
        .sort((a, b) => a.median - b.median);
}


/* ---------------------------------------------------------
   Filters
--------------------------------------------------------- */

function populateFilters() {

    const benchmarkSelect =
        document.getElementById("benchmarkFilter");

    const packageSelect =
        document.getElementById("packageFilter");

    const benchmarks =
        [...new Set(
            DATA.results.map(x => x.benchmark)
        )].sort();

    const packages =
        [...new Set(
            DATA.results.map(x => x.package)
        )].sort();

    for (const benchmark of benchmarks) {

        const option =
            document.createElement("option");

        option.value = benchmark;
        option.textContent = benchmark;

        benchmarkSelect.appendChild(option);
    }

    for (const pkg of packages) {

        const option =
            document.createElement("option");

        option.value = pkg;
        option.textContent = pkg;

        packageSelect.appendChild(option);
    }

    benchmarkSelect.addEventListener(
        "change",
        updateDashboard
    );

    packageSelect.addEventListener(
        "change",
        updateDashboard
    );
}


/* ---------------------------------------------------------
   KPI cards
--------------------------------------------------------- */

function updateStats(aggregates) {

    const fastest = aggregates[0];

    document.getElementById("fastestPackage")
        .textContent =
        fastest ? fastest.package : "—";

    document.getElementById("fastestTime")
        .textContent =
        fastest ? formatSeconds(fastest.median) : "—";


    const allValues =
        aggregates.flatMap(x => x.values);

    document.getElementById("overallMedian")
        .textContent =
        allValues.length
            ? formatSeconds(median(allValues))
            : "—";


    document.getElementById("measurementCount")
        .textContent =
        allValues.length.toLocaleString();


    document.getElementById("packageCount")
        .textContent =
        aggregates.length;
}


/* ---------------------------------------------------------
   Ranking chart
--------------------------------------------------------- */

function updateRankingChart(aggregates) {

    const ctx =
        document.getElementById("rankingChart");

    if (rankingChart) {
        rankingChart.destroy();
    }

    rankingChart = new Chart(ctx, {

        type: "bar",

        data: {
            labels:
                aggregates.map(x => x.package),

            datasets: [{
                label: "Median runtime",

                data:
                    aggregates.map(x => x.median),

                backgroundColor: "#635bff",

                borderRadius: 7,

                borderSkipped: false
            }]
        },

        options: {

            responsive: true,

            maintainAspectRatio: false,

            plugins: {
                legend: {
                    display: false
                },

                tooltip: {
                    callbacks: {
                        label: context =>
                            formatSeconds(context.raw)
                    }
                }
            },

            scales: {

                y: {
                    beginAtZero: true,

                    ticks: {
                        callback: value =>
                            formatSeconds(value)
                    },

                    grid: {
                        color: "rgba(128,128,128,0.12)"
                    }
                },

                x: {
                    grid: {
                        display: false
                    }
                }
            }
        }
    });
}


/* ---------------------------------------------------------
   Repetition chart
--------------------------------------------------------- */

function updateRunsChart(results) {

    const ctx =
        document.getElementById("runsChart");

    if (runsChart) {
        runsChart.destroy();
    }

    const grouped = new Map();

    for (const result of results) {

        if (!grouped.has(result.package)) {
            grouped.set(result.package, []);
        }

        grouped.get(result.package).push(result);
    }

    const datasets = [];

    const colors = [
        "#635bff",
        "#06b6d4",
        "#f59e0b",
        "#10b981",
        "#ef4444",
        "#ec4899"
    ];

    let colorIndex = 0;

    for (const [pkg, packageResults] of grouped) {

        const points = [];

        for (const result of packageResults) {

            for (const measurement of result.measurements) {

                points.push({
                    x: measurement.repetition,
                    y: measurement.elapsed_seconds
                });
            }
        }

        points.sort((a, b) => a.x - b.x);

        datasets.push({
            label: pkg,
            data: points,

            borderColor:
                colors[colorIndex % colors.length],

            backgroundColor:
                colors[colorIndex % colors.length],

            borderWidth: 2,

            pointRadius: 3,

            pointHoverRadius: 7,

            tension: 0.25
        });

        colorIndex++;
    }


    runsChart = new Chart(ctx, {

        type: "scatter",

        data: {
            datasets
        },

        options: {

            responsive: true,

            maintainAspectRatio: false,

            parsing: false,

            plugins: {
                tooltip: {
                    callbacks: {
                        label: context =>
                            `${context.dataset.label}: ${
                                formatSeconds(context.parsed.y)
                            }`
                    }
                }
            },

            scales: {

                x: {
                    type: "linear",

                    title: {
                        display: true,
                        text: "Repetition"
                    },

                    ticks: {
                        precision: 0
                    },

                    grid: {
                        display: false
                    }
                },

                y: {

                    title: {
                        display: true,
                        text: "Runtime"
                    },

                    ticks: {
                        callback: value =>
                            formatSeconds(value)
                    },

                    grid: {
                        color:
                            "rgba(128,128,128,0.12)"
                    }
                }
            }
        }
    });
}


/* ---------------------------------------------------------
   Distribution
--------------------------------------------------------- */

function updateDistribution(aggregates) {

    const container =
        document.getElementById("distributionList");

    container.innerHTML = "";

    if (!aggregates.length) {
        container.innerHTML =
            "<p>No data available.</p>";

        return;
    }

    const globalMin =
        Math.min(...aggregates.map(x => x.min));

    const globalMax =
        Math.max(...aggregates.map(x => x.max));

    const range =
        globalMax - globalMin || 1;


    for (const item of aggregates) {

        const left =
            ((item.min - globalMin) / range) * 100;

        const width =
            ((item.max - item.min) / range) * 100;

        const element =
            document.createElement("div");

        element.className =
            "distribution-item";

        element.innerHTML = `

            <div class="distribution-name">
                ${escapeHtml(item.package)}
            </div>

            <div class="distribution-track">

                <div
                    class="distribution-range"
                    style="
                        left: ${left}%;
                        width: ${Math.max(width, 1)}%;
                    "
                ></div>

            </div>

            <div class="distribution-value">
                ${formatSeconds(item.median)}
            </div>

        `;

        container.appendChild(element);
    }
}


/* ---------------------------------------------------------
   Table
--------------------------------------------------------- */

function updateTable(aggregates) {

    const tbody =
        document.getElementById("resultsTable");

    tbody.innerHTML = "";

    if (!aggregates.length) {
        return;
    }

    const fastestMedian =
        aggregates[0].median;


    for (const item of aggregates) {

        const relative =
            item.median / fastestMedian;

        const tr =
            document.createElement("tr");

        tr.innerHTML = `

            <td>${escapeHtml(item.package)}</td>

            <td>${formatSeconds(item.mean)}</td>

            <td class="${
                item === aggregates[0]
                    ? "fastest"
                    : ""
            }">
                ${formatSeconds(item.median)}
            </td>

            <td>${formatSeconds(item.min)}</td>

            <td>${formatSeconds(item.max)}</td>

            <td>${formatSeconds(item.stddev)}</td>

            <td class="relative">
                ${relative.toFixed(2)}×
            </td>

        `;

        tbody.appendChild(tr);
    }
}


/* ---------------------------------------------------------
   Dashboard update
--------------------------------------------------------- */

function updateDashboard() {

    const results =
        getFilteredResults();

    const aggregates =
        aggregate(results);

    updateStats(aggregates);

    updateRankingChart(aggregates);

    updateRunsChart(results);

    updateDistribution(aggregates);

    updateTable(aggregates);
}


/* ---------------------------------------------------------
   Theme
--------------------------------------------------------- */

function setupTheme() {

    const button =
        document.getElementById("themeToggle");

    const saved =
        localStorage.getItem("benchmark-theme");

    if (saved === "dark") {
        document.body.classList.add("dark");
        button.textContent = "☀";
    }

    button.addEventListener("click", () => {

        document.body.classList.toggle("dark");

        const dark =
            document.body.classList.contains("dark");

        localStorage.setItem(
            "benchmark-theme",
            dark ? "dark" : "light"
        );

        button.textContent =
            dark ? "☀" : "☾";
    });
}


/* ---------------------------------------------------------
   Initialization
--------------------------------------------------------- */

function init() {

    if (!DATA || !DATA.results) {
        console.error(
            "Benchmark data could not be loaded."
        );

        return;
    }

    populateFilters();

    setupTheme();

    document.getElementById("generatedAt")
        .textContent =
        DATA.generated_at
            ? `Data generated ${new Date(
                DATA.generated_at
            ).toLocaleString()}`
            : "";

    updateDashboard();
}


init();
