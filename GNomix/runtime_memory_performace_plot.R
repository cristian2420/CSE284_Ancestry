library(data.table)
library(ggplot2)
library(here)

gnomix <- data.table::fread(here::here("results", "gnomix_stats.tsv"))
rfmix <- data.table::fread(here::here("results", "RFMix_mem_runtime_performance.txt"))

dfout <- rbind(gnomix, rfmix)

dfstats <- dfout[, .(mean_runtime = mean(time_sec, na.rm = T), sd_runtime = sd(time_sec, na.rm = T), mean_memory = mean(memory_gb, na.rm = T), sd_memory = sd(memory_gb, na.rm = T)), by = .(dataset, n_sample, tool)]

png(here::here("results", "plot_runtime.png"))
ggplot(dfstats, aes(x = dataset, y = mean_runtime, color = tool, group = tool)) +
  geom_point(size = 3) +
  geom_errorbar(
    aes(ymin = mean_runtime - sd_runtime, ymax = mean_runtime + sd_runtime),
    width = 0.2
  ) +
  geom_line() +
  labs(title = "Dataset Runtime Performance",
       x = "Dataset", y = "Mean Time (sec)", color = "Tool") +
  theme_minimal()

dev.off()


png(here::here("results", "plot_memory.png")
ggplot(dfstats, aes(x = dataset, y = mean_memory, color = tool, group = tool)) +
  geom_point(size = 3) +
  geom_errorbar(
    aes(ymin = mean_memory - sd_memory, ymax = mean_memory + sd_memory),
    width = 0.2
  ) +
  geom_line() +
  labs(title = "Dataset Memory Performance",
       x = "Dataset", y = "Mean Memory (GB)", color = "Tool") +
  theme_minimal()
dev.off()
