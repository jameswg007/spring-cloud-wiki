========
Sphinx
========

Sphinx
***********

安装 Sphinx
----------------
* http://www.sphinx-doc.org/en/master/usage/installation.html
* https://www.sphinx.org.cn/usage/quickstart.html

搭建 wiki
--------------------
::

    $ sphinx-quickstart

主题
---------------------------
https://sphinx-themes.org/


Wiki语法
****************

gui
------
:guilabel:`&Cancel`

:menuselection:`Start --> Programs`

|today|

:abbr:`LIFO (last-in, first-out)`. （鼠标移上去，出现提示文字）

::

   :guilabel:`&Cancel`
   :menuselection:`Start --> Programs`
   |today|
   :abbr:`LIFO (last-in, first-out)`.

   today_fmt = '%Y-%m-%d' #'%B %d, %Y'

code
-------
所有支持的语言：http://pygments.org/languages/

::

   .. code-block:: ActionScript
      :emphasize-lines: 3,4
      :linenos:


note
-------

.. seealso:: This is a simple **seealso** note.

.. note:: This is a simple **note** note.

.. todo:: This is a simple **todo** note. need add this in conf.py: todo_include_todos=True

.. warning:: This is a simple **warning** note. .. include:: ./todo-tutorial.md

.. admonition:: 文字随便写

   Extensions local to a project should be put within the project’s directory structure.
   Set Python’s module search path, sys.path, accordingly so that Sphinx can find them.
   E.g., if your extension foo.py lies in the exts subdirectory of the project root,
   put into conf.py::
   
      import sys, os
      sys.path.append(os.path.abspath('exts'))
      extensions = ['foo']
   
   You can also install extensions anywhere else on sys.path, e.g. in the site-packages directory.

::

   .. seealso:: This is a simple **seealso** note.
   .. note:: This is a simple **note** note.
   .. todo:: This is a simple **todo** note. need add this in conf.py: todo_include_todos=True
   .. warning:: This is a simple **warning** note. .. include:: ./todo-tutorial.md

   .. admonition:: 文字随便写

      Extensions local to a project should be put within the project’s directory structure.
      Set Python’s module search path, sys.path, accordingly so that Sphinx can find them.
      E.g., if your extension foo.py lies in the exts subdirectory of the project root,
      put into conf.py::
      
         import sys, os
         sys.path.append(os.path.abspath('exts'))
         extensions = ['foo']
      
      You can also install extensions anywhere else on sys.path, e.g. in the site-packages directory.


color
-------

.. raw:: html

    <font color="red">Red word</font>

::

   .. raw:: html

      <font color="red">Red word</font>

includefile
---------------

::

   .. literalinclude:: ../_static/forms-ex600/app/app.component.ts
      :linenos:
      :language: typescript
      :lines: 1, 2-39

   .. code-block:: typescript
      :linenos:

      this.form.controls['make'].valueChanges.subscribe(
         (value) => { console.log(value); }
      );
      this.form.controls['make'].statusChanges.subscribe(
         (value) => { console.log(value); }
      );

   .. include:: ./Application.md

image
---------------
::

   .. image:: images/Figure19-7.png
      :width: 400px
      :align: center
      :height: 200px
      :alt: alternate text


table
---------------

The following table lists some useful lexers (in no particular order).

.. csv-table:: Frozen Delights!
   :header: "Treat", "Quantity", "Description"
   :widths: 15, 10, 30

   "Albatross", 2.99, "On a stick!"
   "Crunchy Frog", 1.49, "If we took the bones out, it wouldn't be
   crunchy, now would it?"
   "Gannet Ripple", 1.99, "On a stick!"

.. list-table:: Frozen Delights!
   :widths: 15 10 30
   :header-rows: 1

   * - Treat
     - Quantity
     - Description
   * - Albatross
     - 2.99
     - On a stick!
   * - Crunchy Frog
     - 1.49
     - | If we took the bones out, it wouldn't be
       | crunchy, now would it?
   * - Gannet Ripple
     - 1.99
     - On a stick!

::

   .. csv-table:: Frozen Delights!
      :header: "Treat", "Quantity", "Description"
      :widths: 15, 10, 30

      "Albatross", 2.99, "On a stick!"
      "Crunchy Frog", 1.49, "If we took the bones out, it wouldn't be
      crunchy, now would it?"
      "Gannet Ripple", 1.99, "On a stick!"

   .. list-table:: Frozen Delights!
      :widths: 15 10 30
      :header-rows: 1

      * - Treat
        - Quantity
        - Description
      * - Albatross
        - 2.99
        - On a stick!
      * - Crunchy Frog
        - 1.49
        - If we took the bones out, it wouldn't be
         crunchy, now would it?
      * - Gannet Ripple
        - 1.99
        - On a stick!

隐藏source
---------------
::

   html_show_sourcelink = False

link
---------------
::

   `link <Python home page_>`_

Custom CSS
---------------
custom stylesheet is _static/css/custom.css::

   ## conf.py

   # These folders are copied to the documentation's HTML output
   html_static_path = ['_static']

   # These paths are either relative to html_static_path
   # or fully qualified paths (eg. https://...)
   html_css_files = [
      'css/custom.css',
   ]


chapters
---------------
::

   # 及上划线表示部分
   * 及上划线表示章节
   =, 小章节
   -, 子章节
   ^, 子章节的子章节
   ", 段落


highlight
------------------
.. highlight:: html

The literal blocks are now highlighted as HTML, until a new directive is found.

::

   <html><head></head>
   <body>This is a text.</body>
   </html>

The following directive changes the hightlight language to SQL.

.. highlight:: sql

::

   SELECT * FROM mytable

.. highlight:: none

From here on no highlighting will be done.

::

   SELECT * FROM mytable


脚注
------------
首先在正文中有个序号  [1]_ ，然后在页面的尾部 ``.. rubric:: 脚注``。

Error
------------
当执行make html命令时出现类似下面的错误信息时，是由于根目录的权限不够导致的，需要执行chmod 777 放开目录权限::

   reading sources... [100%] pages/netflix                                                                                                      
   looking for now-outdated files... none found
   pickling environment... done
   checking consistency... done
   preparing documents... WARNING: search index couldn't be loaded, but not all documents will be built: the index will be incomplete.
   done
   writing output... [100%] pages/netflix                                                                                                       
   generating indices... genindex
   writing additional pages... search


部署到github
**********************
1. 在github上创建仓库，根目录下新建文件夹 ``docs`` 。
2. 拷贝wiki到 ``docs`` 目录下。
3. 提交代码。
4. 使用github账号登陆 `Read the Docs <https://readthedocs.org/_>`_ 网站。
5. 选择导入的github上创建的仓库。
6. 按照步骤一步步操作，最终build结果如下：

.. image:: images/wiki_1.png
   :width: 800px

* link: https://nestjs.readthedocs.io/en/latest/index.html
* demo: https://github.com/murphylan/nest

参考
***********

   #. https://zh-sphinx-doc.readthedocs.io/en/latest/contents.html
   #. `syntax <http://openalea.gforge.inria.fr/doc/openalea/doc/_build/html/source/sphinx/rest_syntax.html#text-syntax-bold-italic-verbatim-and-special-characters>`_
   #. `Using_Sphinx <https://build-me-the-docs-please.readthedocs.io/en/latest/index.html>`_
   #. `directives <https://devopstutodoc.readthedocs.io/en/0.1.0/documentation/doc_generators/sphinx/rest_sphinx/code/literalinclude/literalinclude.html#diff>`_
   #. https://docs.readthedocs.io/en/stable/index.html


.. rubric:: 任何文字（如：脚注）

.. [1] 演示脚注 ``.. include`` directive, 点击左边的【1】迅速定位到上面的 ``脚注`` 处。