  width               = 1100
  height              = 600
  equilateralAltitude = Math.sqrt(3.0) / 2.0
  triangleScale       = 30
  patch_width         = width * 1.1
  patch_height        = height * 1.1

  # Create patch of triangles that spans the view
  shape = seen.Shapes.patch(
    patch_width / triangleScale / equilateralAltitude
    patch_height / triangleScale
  )
  .scale(triangleScale)
  .translate(-patch_width/2, -patch_height/2 + 80)
  .rotx(0)

  seen.Colors.randomSurfaces2(shape)

  model = seen.Models.default().add(shape)

  scene = new seen.Scene
    model    : model
    viewport : seen.Viewports.center(width, height)
    camera   : new seen.Camera
        projection : seen.Projections.ortho()
  
  # Load the object file using jquery
  $.get 'assets/logo.obj', {}, (contents) ->
  # Create shape from object file
    shapeobj = seen.Shapes.obj(contents, false)
    shapeobj.scale(0.25).translate(0,0,-100).rotx(Math.PI/4).roty(-Math.PI/4).rotz(0)
  # Update scene model
    model.add(shapeobj)

  $.get 'assets/background.obj', {}, (contents) ->
  # Create shape from object file
    shapeback = seen.Shapes.obj(contents, false)
    shapeback.scale(1).translate(0,0,-100).rotx(Math.PI/4).roty(-Math.PI/4).rotz(0)
    console.log(shapeback.surfaces[0].points)
  # Update scene model
    model.add(shapeback)


  context = seen.Context('seen-canvas', scene).render()

# Apply animated 3D simplex noise to patch vertices
  t = 0
  noiser = new Simplex3D(shape)
  context.animate()
    .onBefore((t)->
      for surf in shape.surfaces
        for p in surf.points
          p.z = 4*noiser.noise(p.x/8, p.y/8, t*1e-4)
        # Since we're modifying the point directly, we need to mark the surface dirty
        # to make sure the cache doesn't ignore the change
        surf.dirty = true
    )
    .start()
