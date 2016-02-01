/*
 * This code was written by Philipp Zabel <p.zabel at pengutronix.de>
 * and was taken from http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181101.html
 */

/*
 * The CODA driver needs the raw firmware without header in memory order.
 * This is how I converted vpu_fw_imx53.bin from the Freescale BSP into
 * v4l2-coda7541-imx53.bin:
 */

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>

struct fw_header_info {
	u_int8_t  platform[12];
	u_int32_t size;
};

int main(int argc, char *argv[])
{
	int fd, i, n, size;
	struct fw_header_info header;
	u_int32_t *buf;

	if (argc < 3) {
		fprintf(stderr, "usage: %s <infile> <outfile>\n", argv[0]);
		fprintf(stderr, "example: %s vpu_fw_imx53.bin v4l2-coda7541-imx53.bin\n", argv[0]);
		return 0;
	}

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "Failed to open source file '%s'.\n", argv[1]);
		return EXIT_FAILURE;
	}

	n = read(fd, &header, sizeof(header));
	if (n != sizeof(header)) {
		fprintf(stderr, "Failed to read header.\n");
		return EXIT_FAILURE;
	}

	size = header.size * sizeof(u_int16_t);
	buf = malloc(size);
	if (buf == NULL)
		return EXIT_FAILURE;

	n = read(fd, buf, size);
	if (n != size) {
		fprintf(stderr, "Failed to read firmware.\n");
		return EXIT_FAILURE;
	}

	close(fd);

	for (i = 0; i < size / 4; i += 2) {
		u_int32_t tmp = buf[i + 1] << 16 | buf[i + 1] >> 16;
		buf[i + 1] = buf[i] << 16 | buf[i] >> 16;
		buf[i] = tmp;
	}

	fd = open(argv[2], O_RDWR | O_CREAT, 0644);
	if (fd < 0)
		error("Failed to open target file '%s'.\n", argv[2]);

	n = write(fd, buf, size);
	if (n != size)
		error("Failed to write reordered firmware\n");

	close(fd);

	return 0;
}

/*
 * regards
 * Philipp
 */
