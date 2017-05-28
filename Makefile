all:
	python Bang/bang.py
preview:
	python Bang/bang.py
	`echo "${BROWSER} index.html"`&
clean:
	rm -r ./tmp
