FROM python:3

ADD num_gen.py /
ADD requirements.txt /

RUN pip install -r requirements.txt

CMD [ "python", "./num_gen.py" ]