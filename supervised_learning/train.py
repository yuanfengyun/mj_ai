# -*- coding:utf-8 -*-
import logging
logging.getLogger().setLevel(logging.INFO)
import mxnet as mx
import numpy as np

data = np.array([[1],[2],[3],[4],[5],[6],[7],[8],[9],[10]])
label = np.array([1,2,3,4,5,6,7,8,9,10])

batch_size = 1
ntrain = int(data.shape[0]*0.8)
print(ntrain)
#训练数据集迭代器
train_iter = mx.io.NDArrayIter(data[:ntrain, :], label[:ntrain], batch_size, shuffle=True,label_name='lin_reg_label')
#验证数据集迭代器
val_iter = mx.io.NDArrayIter(data[ntrain:, :], label[ntrain:], batch_size,shuffle=False,label_name='lin_reg_label')

#定义网络
net = mx.sym.Variable('data')
Y = mx.symbol.Variable('lin_reg_label')
#输入层
net = mx.sym.FullyConnected(net, name='fc1', num_hidden=1)
#net = mx.sym.Activation(net, name='relu1', act_type="relu")
net =  mx.sym.LinearRegressionOutput(net, label=Y, name='line')

#隐藏层

#输出层
#net = mx.sym.FullyConnected(net, name='fc2', num_hidden=1)
#net = mx.sym.SoftmaxOutput(net, name='softmax')
mx.viz.plot_network(net)

train_iter.reset()

#创建模型
mod = mx.mod.Module(symbol=net,
                    context=mx.cpu(),
                    data_names=['data'],
                    label_names=['lin_reg_label'])

#训练
mod.fit(train_iter,
        eval_data=val_iter,
        optimizer_params={'learning_rate':0.001, 'momentum': 0.9},
        eval_metric='mse',
        num_epoch=8)

#预测
y = mod.predict(val_iter)
print(y)